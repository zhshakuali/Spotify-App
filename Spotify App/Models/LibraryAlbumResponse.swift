//
//  LibraryAlbumResponse.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 16.02.2024.
//

import Foundation

struct LibraryAlbumResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
