//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import XCTest
@testable import Marvel

final class MarvelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!

    @MainActor override func setUpWithError() throws {
        super.setUp()
        viewModel = CharacterListViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    @MainActor func testCharacterLoading() throws {
        let expectation = self.expectation(description: "CharacterLoading")
        viewModel.loadCharacters()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(viewModel.characters.isEmpty, "No characters loaded")
    }

}
