import UIKit

final class MovieQuizPresenter {
    weak var viewController: MovieQuizViewController?

    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers = 0
    var currentQuestion: QuizQuestion?

    var correctAnswersCount: Int {
        return correctAnswers
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    func nextQuestion() {
        currentQuestionIndex += 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }

    var isLastQuestion: Bool {
        return currentQuestionIndex == questionsAmount - 1
    }

    func yesButtonClicked() {
        didAnswer(isYes: true)
    }

    func noButtonClicked() {
        didAnswer(isYes: false)
    }

    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }

        let givenAnswer = isYes
        let isCorrect = givenAnswer == currentQuestion.correctAnswer

        viewController?.showAnswerResult(isCorrect: isCorrect)
    }

    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

    func showNextQuestionOrResults() {
        if isLastQuestion {
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "",
                buttonText: "Сыграть еще раз"
            )
            viewController?.show(quiz: result)
        } else {
            nextQuestion()
            viewController?.requestNextQuestion()
        }
    }
}
