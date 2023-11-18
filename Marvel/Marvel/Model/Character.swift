//
//  Character.swift
//  Marvel
//
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.

import Foundation

// MARK: - Estructuras para manejar datos de la API de Marvel
struct MarvelResponse: Codable {
    let code: Int
    let status: String
    let data: CharacterData
}

struct CharacterData: Codable {
    let offset, limit, total, count: Int
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail
    let comics, series: ComicList
    let stories: StoryList
    let urls: [URLType]
}

struct Thumbnail: Codable {
    let path: String
    let `extension`: String

    // Función para construir la URL completa de la imagen
    func fullPath() -> String {
        let variant = "portrait_medium"
        return "\(path)/\(variant).\(`extension`)"

    }
}

struct ComicList: Codable {
    let items: [Comic]
}

struct Comic: Codable {
    let resourceURI: String
    let name: String
}

struct StoryList: Codable {
    let items: [Story]
}

struct Story: Codable {
    let resourceURI: String
    let name: String
    let type: String
}

struct URLType: Codable {
    let type: String
    let url: String
}
