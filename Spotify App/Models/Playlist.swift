//
//  Playlist.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 02.01.2024.
//

import Foundation

struct Playlist: Codable{
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImages]
    let name: String
    let owner: User
}
