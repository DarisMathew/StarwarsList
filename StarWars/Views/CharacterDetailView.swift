//
//  CharacterDetailView.swift
//  StarWars
//
//  Created by Daris Mathew on 16.09.24.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @StateObject private var viewModel = CharacterDetailViewModel()
    
    var body: some View {
        ZStack {
            List {
                characterNameSection
                homeworldSection
                basicInfoSection
                physicalAttributesSection
                associationsSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Character Details")
            
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchHomeworld(for: character)
            }
        }
    }
    
    // MARK: - ViewBuilders
    
    @ViewBuilder
    private var loadingOverlay: some View {
        ZStack {
            // Blur effect using Material
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .padding()
                .background(
                    Color(.systemBackground).opacity(0.8)
                        .cornerRadius(10)
                )
        }
    }
    
    @ViewBuilder
    private var characterNameSection: some View {
        Section(header: Text("Character Name").font(.headline)) {
            Text(character.name)
        }
    }
    
    @ViewBuilder
    private var homeworldSection: some View {
        if let homeworld = viewModel.homeworld {
            Section(header: Text("Homeworld").font(.headline)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: \(homeworld.name)")
                    Text("Climate: \(homeworld.climate)")
                    Text("Population: \(homeworld.population)")
                    Text("Gravity: \(homeworld.gravity)")
                    Text("Terrain: \(homeworld.terrain)")
                    Text("Diameter: \(homeworld.diameter) km")
                    Text("Rotation Period: \(homeworld.rotationPeriod) hours")
                    Text("Orbital Period: \(homeworld.orbitalPeriod) days")
                    Text("Surface Water: \(homeworld.surfaceWater)%")
                }
            }
        }
    }
    
    @ViewBuilder
    private var basicInfoSection: some View {
        Section(header: Text("Basic Information").font(.headline)) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gender: \(character.gender.capitalized)")
                Text("Birth Year: \(character.birthYear)")
                Text("Homeworld: \(homeworldName)")
            }
        }
    }
    
    var homeworldName: String {
        viewModel.homeworld?.name ?? "N/A"
    }
    
    @ViewBuilder
    private var physicalAttributesSection: some View {
        Section(header: Text("Physical Attributes").font(.headline)) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Height: \(character.height) cm")
                Text("Mass: \(character.mass) kg")
                Text("Hair Color: \(character.hairColor.capitalized)")
                Text("Skin Color: \(character.skinColor.capitalized)")
                Text("Eye Color: \(character.eyeColor.capitalized)")
            }
        }
    }
    
    @ViewBuilder
    private var associationsSection: some View {
        Section(header: Text("Associations").font(.headline)) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Films: \(character.films.count)")
                Text("Species: \(character.species.count)")
                Text("Vehicles: \(character.vehicles.count)")
                Text("Starships: \(character.starships.count)")
            }
        }
    }
}
