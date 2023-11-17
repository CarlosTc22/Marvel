//
//  CharacterDetailView.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 17/11/23.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .padding()

            Text(character.name)
                .font(.largeTitle)
                .padding(.top, 20)

            Text(character.description)
                .font(.body)
                .padding([.top, .bottom], 10)

            Spacer()
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
