import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol!

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticService = StatisticService()
        let questionFactory = QuestionFactory()
            questionFactory.delegate = self
            self.questionFactory = questionFactory
            questionFactory.requestNextQuestion()
        
        alertPresenter = AlertPresenter(viewController: self)
        
}
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else{
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self ] in
            self?.show(quiz: viewModel)
        }
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    static let textQuiz = "Рейтинг этого фильма больше чем 6?"
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        labelCount.text = step.questionNumber
        textLabel.text = step.question
        
        imageView.layer.borderWidth = 0
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        print("Method show(quiz:) called with result: \(result)")
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let defaults = UserDefaults.standard
        print("Содержимое UserDefaults:", defaults.dictionaryRepresentation())

        guard let bestGame = defaults.object(forKey: "bestGame") as? [String: Any] else {
            print("bestGame не найден в UserDefaults")
            return
        }

        
        let bestCorrect = bestGame["correct"] as? Int ?? 0
        let bestTotal = bestGame["total"] as? Int ?? 0
        let formattedDate = Date()
        print("bestCorrect:", bestCorrect)
        print("bestTotal:", bestTotal)
        print("formattedDate:", formattedDate)
        print("totalAccuracy:", statisticService.totalAccuracy)

        let message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        
        Лучший результат:
        \(bestCorrect)/\(bestTotal) (\(formattedDate))
        
        Общая точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        
        print("Generated message: \(message)")

        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText
        ) { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alertPresenter?.showAlert(model: alertModel)
        }
    }


    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
   private func showNextQuestionOrResults(){
        
        if currentQuestionIndex == questionsAmount - 1 {
            
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат \(correctAnswers)/\(questionsAmount)",
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { [weak self] _ in
                guard let self = self else {return}
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }

    
    private func showAnswerResult(isCorrect: Bool) {
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if isCorrect{
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else{
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else{
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

}
