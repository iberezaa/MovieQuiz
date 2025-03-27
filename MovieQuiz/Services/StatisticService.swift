import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrect
        case totalQuestions
        case currentGameAccuracy
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var currentGameAccuracy: Double {
        let correctAnswers = storage.integer(forKey: Keys.totalCorrect.rawValue)
        let totalQuestions = storage.integer(forKey: Keys.totalQuestions.rawValue)

        guard totalQuestions > 0 else { return 0.0 }

        return (Double(correctAnswers) / Double(totalQuestions)) * 100
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

    func store(correct count: Int, total amount: Int) {
        let totalCorrect = storage.integer(forKey: Keys.totalCorrect.rawValue) + count
        let totalQuestions = storage.integer(forKey: Keys.totalQuestions.rawValue) + amount

        storage.set(totalCorrect, forKey: Keys.totalCorrect.rawValue)
        storage.set(totalQuestions, forKey: Keys.totalQuestions.rawValue)

        gamesCount += 1

        let newGameResult = GameResult(correct: count, total: amount, date: Date())

        if newGameResult.isBetterThan(bestGame) {
            bestGame = newGameResult
        }

        let currentGameAccuracy = (Double(count) / Double(amount)) * 100
        
        storage.set(currentGameAccuracy, forKey: Keys.currentGameAccuracy.rawValue)
    }


    private var totalCorrect: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrect.rawValue)
        }
    }

    private var totalQuestions: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
}
