//
//  Network.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 17/11/23.
//

import Foundation

// MARK: - AuthParameters
struct AuthParameters {
    static var apiKey: String {
        "dc93b784b1952fa4293fe83b5e139afd"
    }
    static var timestamp: String {
        "1"
    }
    static var hash: String {
        "a0ef82cb771859cd981b437c21810a9d"
    }
}

// MARK: - APIEndpoint
enum APIEndpoint {
    case characters
    case series(characterId: Int)
    
    var stringValue: String {
        switch self {
        case .characters:
            return "characters"
        case .series(let characterId):
            return "characters/\(characterId)/series"
        }
    }
    
    var url: URL {
        guard let url = URL(string: "\(baseURL)\(self.stringValue)?apikey=\(AuthParameters.apiKey)&ts=\(AuthParameters.timestamp)&hash=\(AuthParameters.hash)") else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    func urlWithPagination(offset: Int, limit: Int) -> URL {
        guard let url = URL(string: "\(baseURL)\(self.stringValue)?apikey=\(AuthParameters.apiKey)&ts=\(AuthParameters.timestamp)&hash=\(AuthParameters.hash)&offset=\(offset)&limit=\(limit)") else {
            fatalError("Invalid URL")
        }
        return url
    }
}

// Configuración Async-Await para la API de Marvel
let baseURL = "https://gateway.marvel.com/v1/public/"

protocol NetworkManagerType {
    func fetchCharacters(offset: Int, limit: Int) async throws -> [Character]
    func fetchSeries(forCharacterId characterId: Int) async throws -> [Series]
}

struct NetworkManager: NetworkManagerType {
    static let shared = NetworkManager()
    
    func fetchCharacters(offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        let request = URLRequest(url: APIEndpoint.characters.urlWithPagination(offset: offset, limit: limit))
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let marvelResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
        return marvelResponse.data.results
        
    }
    
    func fetchSeries(forCharacterId characterId: Int) async throws -> [Series] {
        let request = URLRequest(url: APIEndpoint.series(characterId: characterId).url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let seriesResponse = try JSONDecoder().decode(SeriesResponse.self, from: data)
        return seriesResponse.data.results
    }
}
