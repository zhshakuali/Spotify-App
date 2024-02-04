//
//  Artist.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 02.01.2024.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImages]?
    let external_urls: [String: String]
}
