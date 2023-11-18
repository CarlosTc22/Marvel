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

    func testCharacterListView() throws {
        let firstCharacterCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCharacterCell.waitForExistence(timeout: 10), "No character cell found")
        firstCharacterCell.tap()
    }

}
