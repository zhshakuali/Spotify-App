//
//  AllCategoriesResponse.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 31.01.2024.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
    
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImages]
}

