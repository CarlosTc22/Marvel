//
//  Character.swift
//  Marvel
//  Created by Juan Carlos Torrejón Cañedo on 15/11/23.
//

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

struct Character: Codable, Equatable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail
    let comics: ComicList
    let stories: StoryList
    let urls: [URLType]
}

struct Thumbnail: Codable, Equatable {
    let path: String
    let `extension`: String
    
    func fullPath() -> String {
        let variant = "portrait_xlarge"
        return "\(path)/\(variant).\(`extension`)"
    }
}

struct ComicList: Codable, Equatable {
    let items: [Comic]
}

struct Comic: Codable, Equatable {
    let resourceURI: String
    let name: String
}

struct StoryList: Codable, Equatable {
    let items: [Story]
}

struct Story: Codable, Equatable {
    let resourceURI: String
    let name: String
    let type: String
}

struct URLType: Codable, Equatable {
    let type: String
    let url: String
}

// MARK: - Estructuras para las series de un personaje
struct SeriesResponse: Codable {
    let code: Int
    let status: String
    let data: SeriesData
}

struct SeriesData: Codable {
    let offset, limit, total, count: Int
    let results: [Series]
}

struct Series: Codable {
    let id: Int
    let title: String
    let description: String?
    let thumbnail: Thumbnail
}

