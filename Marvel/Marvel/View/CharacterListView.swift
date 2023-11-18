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
                NavigationLink(destination: CharacterDetailView(character: character)) {
                    CharacterRow(character: character)
                }
            }
            .navigationTitle("Marvel")
        }
        .onAppear {
            viewModel.loadCharacters() 
        }
    }
}

struct CharacterRow: View {
    var character: Character

    var body: some View {
        HStack {
            if let imageUrl = URL(string: "\(character.thumbnail.path).\(character.thumbnail.extension)") {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.fill") // Ícono genérico como placeholder
                }
                .frame(width: 50, height: 50)
            } else {
                Image(systemName: "person.fill") // Ícono genérico si la URL es inválida
                    .frame(width: 50, height: 50)
            }

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

