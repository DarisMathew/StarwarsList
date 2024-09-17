//
//  CharactersListView.swift
//  StarWars
//
//  Created by Daris Mathew on 16.09.24.
//

import SwiftUI

struct CharactersListView: View {
    @StateObject private var viewModel = CharactersViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.characters.isEmpty && viewModel.isLoading {
                    ProgressView("Loading Characters...")
                } else {
                    charactersList
                }
            }
            .navigationTitle("Star Wars Characters")
            .onAppear {
                if viewModel.characters.isEmpty {
                    Task {
                        await viewModel.fetchCharacters()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var charactersList: some View {
        VStack {
            List {
                ForEach(viewModel.characters, id: \.id) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        CharacterRow(character: character)
                    }
                    .listRowBackground(Color.white)
                }
                
                // Load More Button
                if viewModel.canLoadMore {
                    loadMoreButton
                }
            }
        }
    }
    
    @ViewBuilder
    private var loadMoreButton: some View {
        HStack {
            Spacer()
            Button(action: {
                Task {
                    await viewModel.fetchCharacters(loadMore: true)
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.circle")
                        Text("Load More")
                    }
                }
            }
            .disabled(viewModel.isLoading)
            Spacer()
        }
    }
}

struct CharacterRow: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(character.name)
                .font(.headline)
            Text("Gender: \(character.gender.capitalized)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
