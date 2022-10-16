//
//  StorageManager.swift
//  UnsplashApp
//
//  Created by Robert Miller on 14.10.2022.
//

import Foundation
import SDWebImage

struct StorageManager {
    
    static private let userDefaults = UserDefaults.standard
    static let unsplashPhotoKey = "unsplashPhoto"
    static var favoritesList: [UnsplashPhoto] = fetchFavoritesList()
    static var cacheLimitNumber = 90
    
    static func save(_ unsplashPhoto: UnsplashPhoto) {
        StorageManager.favoritesList.append(unsplashPhoto)
        guard let data = try? JSONEncoder().encode(StorageManager.favoritesList) else { return }
        StorageManager.userDefaults.set(data, forKey: StorageManager.unsplashPhotoKey)
        print("Succes saved \(StorageManager.favoritesList.count)")
    }
    
    static func fetchFavoritesList() -> [UnsplashPhoto] {
        guard let data = StorageManager.userDefaults.object(forKey: StorageManager.unsplashPhotoKey) as? Data
        else { return [] }
        guard let favoritesList = try? JSONDecoder().decode([UnsplashPhoto].self, from: data)
        else { return [] }
        return favoritesList
    }
    
    static func deleteFromFavorites(_ unsplashPhoto: UnsplashPhoto) {
        StorageManager.favoritesList = StorageManager.favoritesList.filter { $0.id != unsplashPhoto.id}
        guard let data = try? JSONEncoder().encode(StorageManager.favoritesList) else { return }
        StorageManager.userDefaults.set(data, forKey: StorageManager.unsplashPhotoKey)
    }
    
    static func isInFavorites(unsplashPhoto: UnsplashPhoto) -> Bool {
        StorageManager.favoritesList.contains { favoritePhoto in
            unsplashPhoto.id == favoritePhoto.id
        }
    }
    
    static func clearMemory() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
}
