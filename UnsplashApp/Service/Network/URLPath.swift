//
//  URLPath.swift
//  UnsplashApp
//
//  Created by Robert Miller on 16.10.2022.
//

import Foundation

enum URLPath: String {
   static var fullPath: String {
        "https://api.unsplash.com"
    }
    
    case none = ""
    case incorrect = "incorrect/path"
    case searchPhoto = "/search/photos"
    case randomPhoto = "/photos/random"
    case photoByID = "/photos/testID"
}
