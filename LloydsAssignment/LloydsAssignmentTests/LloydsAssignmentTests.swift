//
//  LloydsAssignmentTests.swift
//  LloydsAssignmentTests
//
//  Created by Amit Aman on 22/05/22.
//

import XCTest
@testable import LloydsAssignment

class LloydsAssignmentTests: XCTestCase {
    
    var locationViewModel : LocationViewModel!
    var weatherViewModel : WeatherViewModel!
    var weatherVC: WeatherViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.locationViewModel = LocationViewModel()
        self.weatherViewModel = WeatherViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.locationViewModel = nil
        self.weatherViewModel = nil
    }
    
    
    func test_getLocation() {
        let locationExpectation = XCTestExpectation(description: "Get Location")
        XCTAssertNotNil(self.locationViewModel.getLocationData())
        locationExpectation.fulfill()
        wait(for: [locationExpectation], timeout: 5.0)
    }
    
    
    func test_searchForPlacemark() {
        let textField = UITextField()
        textField.text = "Delhi"
        let locationExpectation = XCTestExpectation(description: "Search For Placemark")
        _ = self.locationViewModel.searchForPlacemark(text: textField.text ?? "Noida")
            .done({ placemark in
                XCTAssertNotNil(textField, "TextField should not nil.")
                XCTAssertNotNil(placemark)
                locationExpectation.fulfill()
            }).catch({ error in
                XCTAssertNotNil(error, "Error in Search location")
            })
                        
                        wait(for: [locationExpectation], timeout: 5.0)
    }
    
    
    
    
    func test_getIcon() {
        let getIconNameExpectation = XCTestExpectation(description: "Get Icon Name")
        let mockIconName = "01d"
        _ = self.weatherViewModel.getIcon(named: mockIconName)
            .done({ image in
                XCTAssertNotNil(image)
                getIconNameExpectation.fulfill()
            }).catch({ error in
                XCTAssertNotNil(error, "Error occured in get weather")
            })
                        wait(for: [getIconNameExpectation], timeout: 5.0)
    }
    
    func test_getIconFromNetwork() {
        let getIconNameExpectation = XCTestExpectation(description: "Get Icon Name")
        let mockIconName = "01d"
        _ = self.weatherViewModel.getIconFromNetwork(named: mockIconName)
            .done({ image in
                XCTAssertNotNil(image)
                getIconNameExpectation.fulfill()
            }).catch({ error in
                XCTAssertNotNil(error, "Error occured in get weather")
            })
                        wait(for: [getIconNameExpectation], timeout: 5.0)
    }
    
    func test_brokenPromise() {
        XCTAssertNotNil(brokenPromise().validate())
    }
    
    
    func test_seachLocationWithLocationName(){
        let mockLocationName = "Delhi"
        XCTAssertNotNil(self.weatherViewModel.searchLocationWith(location: mockLocationName))
    }
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
