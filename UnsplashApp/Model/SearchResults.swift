//
//  SearchResults.swift
//  UnsplashApp
//
//  Created by Robert Miller on 13.10.2022.
//

import Foundation

struct SearchResults: Codable {
    let total: Int?
    let results: [UnsplashPhoto]
}
