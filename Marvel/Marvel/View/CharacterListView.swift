//
//  CharacterListView.swift
//  Marvel
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

struct CharacterListView<ViewModel: CharacterListViewModelProtocol>: View {
    // MARK: - ViewModel Injection
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        // MARK: - Vista Principal
        NavigationView {
            List {
                ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { (offset, character) in
                    NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(character: character))) {
                        CharacterRow(character: character)
                    }.task {
                        if viewModel.characters.count - 1 == offset {
                            await viewModel.loadCharacters()
                        }
                    }
                }
            }
            .navigationTitle(self.viewModel.title)
        }
        .task {
            if viewModel.characters.isEmpty {
                await viewModel.loadCharacters()
            }
        }
    }
    
    // MARK: - Lista de Personajes
    struct CharacterRow: View {
        var character: Character
        
        var body: some View {
            HStack {
                self.makeAsyncImage(url: URL(string: character.thumbnail.fullPath()),
                                    successImage:  { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                        .lineLimit(2)
                }
                .padding(.leading, 10)
            }
            .padding()
        }
        
        @ViewBuilder
        func makeAsyncImage(url: URL?, successImage: @escaping (Image) -> some View) -> some View {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    successImage(image)
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
        }
    }
}

// MARK: - Previsualización
struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: CharacterListViewModel(title: "Marvel"))
    }
}
