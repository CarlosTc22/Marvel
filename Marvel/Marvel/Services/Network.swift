//
//  Network.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 17/11/23.
//

import Foundation
import CommonCrypto
import Security

// MARK: - AuthParameters
struct AuthParameters {
    static var apiKey: String {
        "dc93b784b1952fa4293fe83b5e139afd"
    }
    static var timestamp: String {
        "1"  // Un valor fijo
    }
    static var hash: String {
        "a0ef82cb771859cd981b437c21810a9d" // Asegúrate de que este hash corresponda al timestamp fijo y a tus claves API
    }
}

// MARK: - APIEndpoint
enum APIEndpoint {
    case characters
    var stringValue: String {
        switch self {
        case .characters: return "characters"
        }
    }
    var url: URL {
        guard let url = URL(string: "\(baseURL)\(self.stringValue)?apikey=\(AuthParameters.apiKey)&ts=\(AuthParameters.timestamp)&hash=\(AuthParameters.hash)") else {
            fatalError("Invalid URL")
        }
        return url
    }
}

// Configuración Async-Await para la API de Marvel
let baseURL = "https://gateway.marvel.com/v1/public/"

class NetworkManager {
    static let shared = NetworkManager()

    func fetchCharacters() async throws -> [Character] {
        let request = URLRequest(url: APIEndpoint.characters.url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let marvelResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
        return marvelResponse.data.results
    }
}
