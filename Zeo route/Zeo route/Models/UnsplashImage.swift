//
//  UnsplashImage.swift
//  Zeo route
//
//  Created by Kudumala on 18/03/25.
//

import UIKit

// MARK: - Image Model
struct UnsplashImage: Codable {
    let id: String?
    let urls: ImageURLs?
    let description:String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case urls = "urls"
        case description = "description"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.urls = try container.decodeIfPresent(ImageURLs.self, forKey: .urls)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}

struct ImageURLs: Codable {
    let small: String?
    
    enum CodingKeys: String, CodingKey {
        case small = "small"
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.small = try container.decodeIfPresent(String.self, forKey: .small)
    }
}

// MARK: - Image Cache
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
