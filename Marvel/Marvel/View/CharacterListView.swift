//
//  CharacterListView.swift
//  Marvel
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

struct CharacterListView<ViewModel: ObservableObject & CharacterListViewModelProtocol>: View {
    // MARK: - ViewModel Injection
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        // MARK: - Vista Principal
        NavigationView {
                List {
                    ForEach(viewModel.characters, id: \.id) { character in
                        NavigationLink(destination: CharacterDetailView(character: character, viewModel: CharacterDetailViewModel())) {
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
    
    // MARK: - Lista de Personajes
    struct CharacterRow: View {
        var character: Character
        
        var body: some View {
            HStack {
                AsyncImage(url: URL(string: character.thumbnail.fullPath())) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure(_):
                        Image(systemName: "photo") // Imagen de error
                    case .empty:
                        ProgressView() // Cargando...
                    @unknown default:
                        EmptyView() // Por si acaso
                    }
                }
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                        .lineLimit(2)
                }
                .padding(.leading, 10)
            }
            .padding()
        }
    }
}

// MARK: - Previsualización
struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: CharacterListViewModel())
    }
}
