//  CharacterListView.swift
//  Marvel
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.

import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.characters, id: \.id) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        CharacterRow(character: character)
                    }
                }
                // Vista al final de la lista para cargar más personajes
                if viewModel.canLoadMoreCharacters {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .onAppear {
                        viewModel.loadCharacters()
                    }
                }
            }
            .navigationTitle("Marvel")
        }
        .onAppear {
            if viewModel.characters.isEmpty {
                viewModel.loadCharacters()
            }
        }
    }
}

struct CharacterRow: View {
    var character: Character

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.thumbnail.fullPath())) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if phase.error != nil {
                    // Si hay un error, lo muestra aquí para depurar
                    Text("Error al cargar la imagen")
                } else {
                    Image(systemName: "person.fill")
                }
            }
            .frame(width: 125, height: 125)
            .aspectRatio(contentMode: .fill)
            .clipped()

            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
            }
            .frame(minHeight: 100)
        }
        .onAppear {
            // Imprimir la URL para depuración
            print("Cargando imagen desde URL: \(character.thumbnail.fullPath())")
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: CharacterListViewModel())
    }
}
