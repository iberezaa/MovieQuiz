import Foundation

protocol StatisticServiceProtocol{
    var gamesCount: Int {get}
    var bestGame: GameResult {get}
    var currentGameAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
