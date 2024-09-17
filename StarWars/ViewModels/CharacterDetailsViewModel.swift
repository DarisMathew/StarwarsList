//
//  CharacterDetailsViewModel.swift
//  StarWars
//
//  Created by Daris Mathew on 16.09.24.
//

import Foundation

@MainActor
class CharacterDetailViewModel: ObservableObject {
    @Published var homeworld: Planet? = nil
    @Published var isLoading: Bool = false
    
    func fetchHomeworld(for character: Character) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let planet = try await APIService.shared.fetchHomeworld(for: character.homeworld)
            homeworld = planet
        } catch {
            print("Failed to fetch homeworld: \(error.localizedDescription)")
        }
    }
}
