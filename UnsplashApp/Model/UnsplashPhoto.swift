//
//  UnsplashPhoto.swift
//  UnsplashApp
//
//  Created by Robert Miller on 15.10.2022.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String
    let created_at: String?
    let width: Int
    let height: Int
    let downloads: Int?
    let description: String?
    let urls: [URLKind.RawValue:String]
    let location: Location?
    let user: UnsplashUser?
}
