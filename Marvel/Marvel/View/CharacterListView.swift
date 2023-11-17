//
//  CharacterListView.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.characters, id: \.name) { character in
                CharacterRow(character: character)
            }
            .navigationTitle("Marvel")
        }
        .onAppear {
            viewModel.fetchCharacters()
        }
    }
}

struct CharacterRow: View {
    var character: Character

    var body: some View {
        HStack {
            Image(systemName: "person.fill") // Ícono genérico
                .resizable()
                .frame(width: 50, height: 50)
                .padding()

            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                Text(character.description)
                    .font(.subheadline)
            }
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: CharacterListViewModel())
    }
}


