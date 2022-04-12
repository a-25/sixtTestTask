import XCTest
@testable import Sixt
import Alamofire

class ErrorMessageServiceTest: XCTestCase {
    private var messageService: ErrorMessageService!

    override func setUpWithError() throws {
        messageService = ErrorMessageService()
    }

    func testGetCarMessage() throws {
        let errorList: [Error] = [
            CarNetworkError.carListUnknown,
            CarNetworkError.networkError(error: AFError.sessionDeinitialized),
            MockError.testError
        ]
        let messagesList: [String?] = [
            "Please, check the internet connection.",
            "Maybe a parsing error or a network timeout",
            nil
        ]
        let receivedMessagesList = errorList.map { messageService.getCarMessage(for: $0) }
        XCTAssertEqual(messagesList, receivedMessagesList)
    }
}
