//
//  ContentView.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CharacterListView(viewModel: CharacterListViewModel(title: "Marvel"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
