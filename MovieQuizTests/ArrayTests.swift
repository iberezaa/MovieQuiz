import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws{
        // Дано
        let array = [1, 1, 2, 3, 5]
        
        // Когда
        let value = array[safe: 2]
        
        // Тогда
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    
    func testGetValueOutOfRange() throws{
        // Дано
        let array = [1, 1, 2, 3, 5]
        
        // Когда
        let value = array[safe: 20]
        
        // Тогда
        XCTAssertNil(value)
    }
}
