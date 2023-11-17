//
//  CharacterListViewModel.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = [
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York"),
    Character(name: "Spider-Man", description: "Héroe arácnido de Nueva York")]

    func fetchCharacters() {
        // Api
    }
}

