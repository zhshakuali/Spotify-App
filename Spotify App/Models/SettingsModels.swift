//
//  SettingsModels.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 12.01.2024.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
    
}
