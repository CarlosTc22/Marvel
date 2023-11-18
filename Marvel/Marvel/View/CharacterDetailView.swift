//
//  CharacterDetailView.swift
//  Marvel
//  Created by Juan Carlos Torrejón Cañedo on 17/11/23.
//

import SwiftUI

// MARK: - CharacterDetailView
struct CharacterDetailView<ViewModel: ObservableObject & CharacterDetailViewModelProtocol>: View {
    let character: Character
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                // MARK: - Imagen
                AsyncImage(url: URL(string: character.thumbnail.fullPath())) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 450)
                            .cornerRadius(10)
                    case .failure(_), .empty:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 450)
                            .cornerRadius(10)
                            .padding()
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // MARK: - Nombre
                Text(character.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                
                // MARK: - Descripcion
                if !character.description.isEmpty {
                    Text(character.description)
                        .font(.body)
                        .padding()
                }
                
                // MARK: - Series Section
                if viewModel.isLoading {
                    ProgressView("Loading series...")
                } else if !viewModel.seriesList.isEmpty {
                    Text("Series Featuring \(character.name)")
                        .font(.headline)
                        .padding()
                    
                    // MARK: - Series List
                    ForEach(viewModel.seriesList, id: \.id) { series in
                        SeriesRow(series: series)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadSeries(forCharacterId: character.id)
        }
    }
    
    // MARK: - SeriesRow View
    struct SeriesRow: View {
        var series: Series
        
        // MARK: - Body
        var body: some View {
            HStack {
                // MARK: - Series Image
                AsyncImage(url: URL(string: series.thumbnail.fullPath())) { phase in
                    // Image handling code...
                }
                .frame(width: 80, height: 120)
                .cornerRadius(5)
                
                // MARK: - Series Details
                VStack(alignment: .leading) {
                    Text(series.title)
                        .font(.headline)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(series.description ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.leading, 10)
                
                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.leading, 16)
        }
    }
}
