//
//  FeaturedPlaylistsResponse.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 18.01.2024.
//

import Foundation

struct FeaturedPlaylistsPesponse: Codable {
    let playlists: FeaturedPlaylists
    
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: FeaturedPlaylists
}

struct FeaturedPlaylists: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

