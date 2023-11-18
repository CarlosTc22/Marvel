// CharacterDetailView.swift
// Marvel
// Created by Juan Carlos Torrejón Cañedo on 17/11/23.

import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack {
                // Usar AsyncImage para cargar la imagen desde la URL
                AsyncImage(url: URL(string: character.thumbnail.fullPath())) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    } else if phase.error != nil {
                        // Mostrar un placeholder o un mensaje de error si la imagen no se puede cargar
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    } else {
                        // Placeholder mientras la imagen se carga
                        ProgressView()
                            .frame(width: 300, height: 300)
                    }
                }
                .padding()

                Text(character.name)
                    .font(.largeTitle)
                    .padding(.top, 20)

                Text(character.description.isEmpty ? "No description available." : character.description)
                    .font(.body)
                    .padding([.top, .bottom], 10)
            }
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
