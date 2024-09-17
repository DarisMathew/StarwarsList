//
//  Character.swift
//  StarWars
//
//  Created by Daris Mathew on 16.09.24.
//

import Foundation

struct Character: Identifiable, Codable, Hashable {
    var id: String { url }
    let name: String
    let height: String
    let mass: String
    let birthYear: String
    let gender: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, height, mass, gender, homeworld, films, species, vehicles, starships, created, edited, url
        case birthYear = "birth_year"
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
    }
}

struct CharactersResponse: Codable {
    let results: [Character]
    let next: String?
}

