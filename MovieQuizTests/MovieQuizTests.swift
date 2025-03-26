import XCTest
@testable import MovieQuiz

class MovieQuizTests: XCTestCase {

    var viewController: MovieQuizViewController!

    override func setUp() {
        super.setUp()
        viewController = MovieQuizViewController()
    }

    func testShowAnswerResult_correctAnswer() {
        let initialCorrectAnswers = viewController.correctAnswers
        viewController.showAnswerResult(isCorrect: true)
        XCTAssertEqual(viewController.correctAnswers, initialCorrectAnswers + 1)
    }

    func testShowAnswerResult_incorrectAnswer() {
        let initialCorrectAnswers = viewController.correctAnswers
        viewController.showAnswerResult(isCorrect: false)
        XCTAssertEqual(viewController.correctAnswers, initialCorrectAnswers)
    }
}
