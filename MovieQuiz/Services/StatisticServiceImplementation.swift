/*
import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    var totalAccuracy: Double {
        get {
            let totalCorrect = storage.integer(forKey: Keys.totalCorrect.rawValue)
            let totalQuestions = storage.integer(forKey: Keys.totalQuestions.rawValue)
            guard totalQuestions > 0 else { return 0 }
            return (Double(totalCorrect) / Double(totalQuestions)) * 100
        }
    }

    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrect
        case totalQuestions
    }

    private var correctAnswers: Int
    private var totalQuestions: Int

    init(correctAnswers: Int = 0, totalQuestions: Int = 0) {
        self.correctAnswers = correctAnswers
        self.totalQuestions = totalQuestions
    }

    var correct: Int {
        return correctAnswers
    }

    var total: Int {
        return totalQuestions
    }

    func setCorrectAnswers(correct: Int) {
        correctAnswers = correct
    }

    func setTotalQuestions(total: Int) {
        totalQuestions = total
    }

    func store(correct count: Int, total amount: Int) {
        // Обновляем количество правильных ответов и вопросов
        let totalCorrect = storage.integer(forKey: Keys.totalCorrect.rawValue) + count
        let totalQuestions = storage.integer(forKey: Keys.totalQuestions.rawValue) + amount

        storage.set(totalCorrect, forKey: Keys.totalCorrect.rawValue)
        storage.set(totalQuestions, forKey: Keys.totalQuestions.rawValue)

        // Увеличиваем счетчик игр
        gamesCount += 1

        // Новый результат игры
        let newGameResult = GameResult(correct: count, total: amount, date: Date())

        // Проверяем, если новый результат лучше, сохраняем его
        if newGameResult.isBetterThan(bestGame) {
            bestGame = newGameResult
        }
    }
}
*/
