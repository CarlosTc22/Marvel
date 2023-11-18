//
//  CharacterListViewModel.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

// MARK: - Protocolo -
protocol CharacterListViewModelProtocol: ObservableObject {
    var characters: [Character] { get }
    var canLoadMoreCharacters: Bool { get }
    func loadCharacters()
}

// MARK: - Clase -
@MainActor
class CharacterListViewModel: CharacterListViewModelProtocol {
    @Published var characters: [Character] = []
    private var offset = 0
    private let limit = 20
    private (set) var canLoadMoreCharacters = true
    private var isLoading = false

    func loadCharacters() {
        guard canLoadMoreCharacters && !isLoading else { return }
        
        isLoading = true
        Task {
            do {
                let fetchedCharacters = try await NetworkManager.shared.fetchCharacters(offset: offset, limit: limit)
                if fetchedCharacters.count < limit {
                    canLoadMoreCharacters = false
                }
                DispatchQueue.main.async {
                    self.characters.append(contentsOf: fetchedCharacters)
                    self.offset += fetchedCharacters.count
                }
            } catch {
                print("Error fetching characters: \(error)")
            }
            isLoading = false
        }
    }
}
