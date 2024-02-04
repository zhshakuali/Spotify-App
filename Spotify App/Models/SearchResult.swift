//
//  SearchResult.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 01.02.2024.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
    case album(model: Album)

}
