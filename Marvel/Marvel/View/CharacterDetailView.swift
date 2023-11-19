//
//  CharacterDetailView.swift
//  Marvel
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

// MARK: - CharacterDetailView
struct CharacterDetailView<ViewModel: CharacterDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                CharacterImage(url: URL(string: viewModel.character.thumbnail.fullPath()), viewModel: viewModel)
                
                // MARK: - Nombre
                Text(viewModel.character.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                
                // MARK: - Descripcion
                if !viewModel.character.description.isEmpty {
                    Text(viewModel.character.description)
                        .font(.body)
                        .padding()
                }
                
                // MARK: - Series Section
                SeriesSection(viewModel: viewModel)
            }
            .padding()
        }
        .navigationTitle(viewModel.character.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadSeries(forCharacterId: viewModel.character.id)
        }
    }
    
    @ViewBuilder
    private func CharacterImage(url: URL?, viewModel: ViewModel) -> some View {
        AsyncImage(url: url) { phase in
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
    }
    
    @ViewBuilder
    private func SeriesSection(viewModel: ViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView("Loading series...")
        } else if !viewModel.seriesList.isEmpty {
            Text("Series Featuring \(viewModel.character.name)")
                .font(.headline)
                .padding()
            
            ForEach(viewModel.seriesList, id: \.id) { series in
                SeriesRow(series: series, viewModel: viewModel)
            }
        }
    }
}

// MARK: - SeriesRow View
struct SeriesRow<ViewModel: CharacterDetailViewModelProtocol>: View {
    var series: Series
    var viewModel: ViewModel
    
    var body: some View {
        HStack {
            makeAsyncImage(url: URL(string: series.thumbnail.fullPath()),
                           successImage: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 120)
                    .cornerRadius(5)
            })
            .padding()
            
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
    
    @ViewBuilder
    private func makeAsyncImage(url: URL?, successImage: @escaping (Image) -> some View) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                successImage(image)
            case .failure(_):
                Image(systemName: "photo") // Imagen de error
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 120)
                    .cornerRadius(5)
            case .empty:
                ProgressView() // Cargando...
                    .frame(width: 80, height: 120)
            @unknown default:
                EmptyView() // Por si acaso
            }
        }
    }
}

