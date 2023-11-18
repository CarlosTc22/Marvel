//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 18/11/23.
//

import Foundation

// MARK: - Protocolo -
protocol CharacterDetailViewModelProtocol: ObservableObject {
    var seriesList: [Series] { get }
    var isLoading: Bool { get set }
    func loadSeries(forCharacterId id: Int) async
}

// MARK: - Clase -
class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    @Published var seriesList: [Series] = []
    @Published var isLoading: Bool = true

    func loadSeries(forCharacterId id: Int) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }

        do {
            let fetchedSeries = try await NetworkManager.shared.fetchSeries(forCharacterId: id)
            DispatchQueue.main.async {
                self.seriesList = fetchedSeries
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching series: \(error)")
                self.isLoading = false
            }
        }
    }
}

