//
// CharacterDetailView.swift
// Marvel
// Created by Juan Carlos Torrejón Cañedo on 17/11/23.

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @State private var seriesList: [Series] = []
    @State private var isLoading: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Detalles del personaje
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
                .frame(width: 300, height: 225)
                .padding()

                Text(character.name)
                    .font(.largeTitle)
                    .padding(.top, 20)

                // Descripción del personaje
                if !character.description.isEmpty {
                    Text(character.description)
                        .font(.body)
                        .padding([.top, .bottom], 10)
                }

                // Sección de series
                if isLoading {
                    ProgressView("Loading series...")
                } else {
                    if !seriesList.isEmpty {
                        Text("Series")
                            .font(.headline)
                            .padding([.top, .bottom], 10)

                        ForEach(seriesList, id: \.id) { series in
                            SeriesRow(series: series)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadSeries()
        }
    }

    func loadSeries() {
        Task {
            do {
                isLoading = true
                self.seriesList = try await NetworkManager.shared.fetchSeries(forCharacterId: character.id)
            } catch {
                print("Error fetching series: \(error)")
            }
            isLoading = false
        }
    }
}

struct SeriesRow: View {
    var series: Series

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: series.thumbnail.fullPath())) { phase in
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
            .frame(width: 150, height: 225)

            VStack(alignment: .leading) {
                Text(series.title)
                    .font(.headline)
                Text(series.description ?? "")
                    .font(.body)
            }
        }
        .padding()
    }
}

