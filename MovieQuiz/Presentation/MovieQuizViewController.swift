import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Properties
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
        
        showLoadingIndicator()
    }

    // MARK: - UI Updates
    func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        labelCount.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            self?.presenter.restartGame()
        }

        alertPresenter?.showAlert(model: alertModel)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            yesButton.isEnabled = false
            noButton.isEnabled = false
        }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            self?.presenter.restartGame()
        }

        alertPresenter?.showAlert(model: model)
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
