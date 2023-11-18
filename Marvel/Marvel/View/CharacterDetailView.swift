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
                .frame(width: 300, height: 300)
                .padding()

                Text(character.name)
                    .font(.largeTitle)
                    .padding(.top, 20)

                Text(character.description.isEmpty ? "No description available." : character.description)
                    .font(.body)
                    .padding([.top, .bottom], 10)

                // Lista de series
                if isLoading {
                    ProgressView("Loading series...")
                } else {
                    Text("Series")
                        .font(.headline)
                        .padding([.top, .bottom], 10)

                    ForEach(seriesList, id: \.id) { series in
                        SeriesRow(series: series)
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
            .frame(width: 100, height: 100)

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


// Vista previa con datos de muestra
struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Ejemplo de personaje para la vista previa
        let sampleCharacter = Character(id: 1, name: "Spider-Man", description: "Friendly neighborhood Spider-Man", thumbnail: Thumbnail(path: "https://example.com/image", extension: "jpg"), comics: ComicList(items: []), stories: StoryList(items: []), urls: [])
        
        CharacterDetailView(character: sampleCharacter)
    }
}
