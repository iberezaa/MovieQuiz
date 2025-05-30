import Foundation

class QuestionFactory: QuestionFactoryProtocol{
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?){
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    } 
    /*
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
    */
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
           do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomThreshold = Float(Int.random(in: 5...9))
            let text = "Рейтинг этого фильма больше, чем \(randomThreshold)?"
            let correctAnswer = rating > randomThreshold
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)

            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
        
}
