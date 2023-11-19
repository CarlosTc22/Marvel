//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import XCTest
@testable import Marvel

final class MarvelTests: XCTestCase {
    
    @MainActor func testCharacterLoading() throws {
        Task {
            let characters = [Character(id: 0, name: "name", description: "desc",
                                        thumbnail: Thumbnail(path: "", extension: ""), comics: .init(items: []),
                                        stories: .init(items: []), urls: .init())]
            let viewModel = CharacterListViewModel(title: "Marvel",
                                                   networkManager: MockNetworkManager(characters: characters))
            await viewModel.loadCharacters()
            
            XCTAssertFalse(viewModel.canLoadMoreCharacters)
            XCTAssertEqual(viewModel.characters, characters)
        }
    }
    
    @MainActor func testCharacterLoadingWhenResponseIsEmpty() throws {
        Task {
            let characters = [Character]()
            let viewModel = CharacterListViewModel(title: "Marvel",
                                                   networkManager: MockNetworkManager(characters: characters))
            await viewModel.loadCharacters()
            
            XCTAssertFalse(viewModel.canLoadMoreCharacters)
            XCTAssertEqual(viewModel.characters, characters)
        }
    }
    
    @MainActor func testTitle() throws {
        Task {
            let characters = [Character]()
            let viewModel = CharacterListViewModel(title: "Marvel",
                                                   networkManager: MockNetworkManager(characters: characters))
            await viewModel.loadCharacters()
            
            XCTAssertEqual(viewModel.title, "Marvel")
        }
    }
    
}

struct MockNetworkManager: NetworkManagerType {
    
    private let characters: [Character]
    
    init(characters: [Character]) {
        self.characters = characters
    }
    
    func fetchCharacters(offset: Int, limit: Int) async throws -> [Marvel.Character] {
        return characters
    }
    
    func fetchSeries(forCharacterId characterId: Int) async throws -> [Marvel.Series] {
        return []
    }
}

