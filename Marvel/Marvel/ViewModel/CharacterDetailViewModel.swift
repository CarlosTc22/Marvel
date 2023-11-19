//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 18/11/23.
//

import Foundation

// MARK: - Protocolo -
@MainActor
protocol CharacterDetailViewModelProtocol: ObservableObject {
    var seriesList: [Series] { get }
    var isLoading: Bool { get set }
    var character: Character { get }
    func loadSeries(forCharacterId id: Int) async
}

// MARK: - Clase -
@MainActor
class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    @Published var seriesList: [Series] = []
    @Published var isLoading: Bool = true
    
    private(set) var character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    func loadSeries(forCharacterId id: Int) async {
        self.isLoading = true
        do {
            let fetchedSeries = try await NetworkManager.shared.fetchSeries(forCharacterId: id)
            self.seriesList = fetchedSeries
            self.isLoading = false
        } catch {
            print("Error fetching series: \(error)")
            self.isLoading = false
        }
    }
}
