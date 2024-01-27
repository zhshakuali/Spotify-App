//
//  AlbumDetailsResponse.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 22.01.2024.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let name: String
    let images: [APIImages]
    let label: String
    let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}

