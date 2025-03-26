import Foundation

class QuestionFactory: QuestionFactoryProtocol{
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: MovieQuizViewController.textQuiz,
            correctAnswer: false)
    ]
    
    func requestNextQuestion(){
        guard let index = (0..<questions.count).randomElement() else{
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
    weak var delegate: QuestionFactoryDelegate?
    
}
