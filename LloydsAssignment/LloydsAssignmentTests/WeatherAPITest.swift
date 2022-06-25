//
//  WeatherAPITest.swift
//  LloydsAssignmentTests
//
//  Created by Amit Aman on 25/06/22.
//

import XCTest
@testable import LloydsAssignment

class WeatherAPITest: XCTestCase {
    
    var serviceApi : APIServiceManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.serviceApi = APIServiceManager()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_getWeatherSuccessAndFailure() {
        let getWeatherExpectation = XCTestExpectation(description: "Get Weather")
        let mockLat = 37.33233141
        let mockLong = 122.03121860
        self.serviceApi.getWeatherData(with: mockLat, long: mockLong, nameSpacer: .promise)
            .done { data,response in
                if (response as? HTTPURLResponse)?.statusCode == 200 {
                    //success
                    XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
                } else {
                    //Failure
                    XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 404)
                }
                XCTAssertNotNil(data, "WeatherInfo is not nill")
                XCTAssertNotNil(response, "response is not nill")
                getWeatherExpectation.fulfill()
            }.catch({ error in
                XCTAssertNotNil(error, "Error occured in get weather")
            })
        wait(for: [getWeatherExpectation], timeout: 5.0)
                
    }
    
    func test_getIconNameSuccessAndFailure() {
        let getWeatherExpectation = XCTestExpectation(description: "Get Weather icon from url.")
        let mockIconName = "02d"
        self.serviceApi.getIconName(with: mockIconName, nameSpacer: .promise)
            .done { data,response in
                if (response as? HTTPURLResponse)?.statusCode == 200 {
                    //success
                    XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
                } else {
                    //Failure
                    XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 404)
                }
                XCTAssertNotNil(data, "WeatherInfo is not nill")
                XCTAssertNotNil(response, "response is not nill")
                getWeatherExpectation.fulfill()
            }.catch({ error in
                XCTAssertNotNil(error, "Error occured in get weather")
            })
        wait(for: [getWeatherExpectation], timeout: 5.0)
                
    }
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
