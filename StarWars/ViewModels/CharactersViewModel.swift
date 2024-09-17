//
//  CharactersViewModel.swift
//  StarWars
//
//  Created by Daris Mathew on 16.09.24.
//

import Foundation

@MainActor
class CharactersViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var nextPageURL: String? = nil
    @Published var canLoadMore = false
    
    func fetchCharacters(loadMore: Bool = false) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response: CharactersResponse
            if loadMore, let nextPageURL = nextPageURL {
                response = try await APIService.shared.fetchCharacters(from: nextPageURL)
            } else {
                response = try await APIService.shared.fetchCharacters()
            }
            
            if loadMore {
                characters.append(contentsOf: response.results)
            } else {
                characters = response.results
            }
            
            nextPageURL = response.next
            canLoadMore = nextPageURL != nil
        } catch {
            print("Failed to fetch characters: \(error.localizedDescription)")
        }
        
    }
}

