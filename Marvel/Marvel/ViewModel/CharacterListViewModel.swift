//
//  CharacterListViewModel.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []

    func loadCharacters() {
        Task {
            do {
                let fetchedCharacters = try await NetworkManager.shared.fetchCharacters()
                self.characters = fetchedCharacters 
            } catch {
                print("Error fetching characters: \(error)")
                // Manejar el error según sea necesario
            }
        }
    }
}
