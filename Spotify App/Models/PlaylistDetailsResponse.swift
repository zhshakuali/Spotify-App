//
//  PlaylistDetailsResponse.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 25.01.2024.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let name: String
    let id: String
    let images: [APIImages]
    let external_urls: [String: String]
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
