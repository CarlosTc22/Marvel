//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import XCTest

final class MarvelUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAppLaunches() throws {
        XCTAssert(app.wait(for: .runningForeground, timeout: 10), "App did not launch properly.")
    }
    
    func testScreenRotation() {
        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssert(app.wait(for: .runningForeground, timeout: 5), "App did not rotate to landscape mode properly.")
        XCUIDevice.shared.orientation = .portrait
        XCTAssert(app.wait(for: .runningForeground, timeout: 5), "App did not rotate back to portrait mode properly.")
    }
}
