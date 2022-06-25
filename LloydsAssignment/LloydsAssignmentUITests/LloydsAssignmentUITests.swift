//
//  LloydsAssignmentUITests.swift
//  LloydsAssignmentUITests
//
//  Created by Amit Aman on 22/05/22.
//

import XCTest

class LloydsAssignmentUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testSearchCityTextField() {
        let textField = app.textFields["Search for a city or location"]
        XCTAssertTrue(textField.exists, "Text field doesn't exist")
        textField.tap()
        textField.typeText("Noida")
        XCTAssertEqual(textField.value as! String, "Noida", "Text field value is not correct")
        
    }
    
    func testStaticLabel() {
        let cityLabel = app.staticTexts["Cupertino"]
        let tempLabel = app.staticTexts["21°C"]
        let weatherStatusLabel = app.staticTexts["BROKEN CLOUDS"]
        
        XCTAssertTrue(cityLabel.exists, "City label doesn't exist")
        cityLabel.tap()
        XCTAssertEqual(cityLabel.label, "Cupertino")
        
        XCTAssertTrue(tempLabel.exists, "Temp label doesn't exist")
        tempLabel.tap()
        XCTAssertEqual(tempLabel.label, "21°C")
       
        XCTAssertTrue(weatherStatusLabel.exists, "Weather status label doesn't exist")
        weatherStatusLabel.tap()
        XCTAssertEqual(weatherStatusLabel.label, "BROKEN CLOUDS")
                
    }
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
