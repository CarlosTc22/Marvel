//
//  CharacterListViewModel.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

// MARK: - Protocolo -
@MainActor
protocol CharacterListViewModelProtocol: ObservableObject {
    var title: String { get }
    var characters: [Character] { get }
    var canLoadMoreCharacters: Bool { get }
    func loadCharacters() async
}

// MARK: - Clase -
@MainActor
class CharacterListViewModel: CharacterListViewModelProtocol {
    @Published var characters: [Character] = []
    private var offset = Int.zero
    private let limit = 20
    private(set) var canLoadMoreCharacters = true
    private var isLoading = false
    var title: String
    
    private(set) var networkManager: NetworkManagerType
    
    init(title: String, networkManager: NetworkManagerType = NetworkManager.shared) {
        self.title = title
        self.networkManager = networkManager
    }
    
    func loadCharacters() async {
        guard canLoadMoreCharacters && !isLoading else { return }
        
        isLoading = true
        do {
            let fetchedCharacters = try await networkManager.fetchCharacters(offset: offset, limit: limit)
            if fetchedCharacters.count < limit {
                canLoadMoreCharacters = false
            }
            self.characters.append(contentsOf: fetchedCharacters)
            self.offset += fetchedCharacters.count
        } catch {
            print("Error fetching characters: \(error)")
        }
        isLoading = false
    }
}

