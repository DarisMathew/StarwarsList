//
//  APIService.swift
//  StarWars
//
//  Created by Daris Mathew on 16.09.24.
//

import Foundation

enum StarWarsAPIError: Error, LocalizedError {
    case invalidURL
    case decodingError(Error)
    case badResponse(URLResponse)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .decodingError(let decodingError):
            return "The data received was invalid. \nError: \(decodingError)"
        case .badResponse(let httpResponse):
            return "The response from the server was not as expected. \nResponse: \(httpResponse)"
        }
    }
}

class APIService {
    static let shared = APIService()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let baseUrlString = "https://swapi.dev/api"
    
    private var peopleUrl: String {
        return "\(baseUrlString)/people"
    }

    private func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw StarWarsAPIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw StarWarsAPIError.badResponse(response)
        }
        
        do {
           return try decoder.decode(T.self, from: data)
        } catch {
            throw StarWarsAPIError.decodingError(error)
        }
    }
    
    func fetchCharacters(from urlString: String? = nil) async throws -> CharactersResponse {
        let url = urlString ?? peopleUrl
        return try await fetchData(from: url)
    }
    
    func fetchHomeworld(for urlString: String) async throws -> Planet {
        return try await fetchData(from: urlString)
    }
}
