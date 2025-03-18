//
//  APIManager.swift
//  Zeo route
//
//  Created by Kudumala on 18/03/25.
//

import Foundation

// MARK: - API Manager
class APIManager {
    
    static let shared = APIManager()
    
    func fetchImages(page: Int, perPage: Int = 20) async throws -> [UnsplashImage] {
        guard let url = URL(string: "\(Secrets.baseURL.rawValue)?page=\(page)&per_page=\(perPage)&client_id=\(Secrets.clientID.rawValue)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([UnsplashImage].self, from: data)
    }
}

 enum Secrets: String {
    case clientID = "RayUxznRSEMykOdLblVfZ2LsMa1zc2hN7ONFXwmpU4I"
    case baseURL = "https://api.unsplash.com/photos"
}
