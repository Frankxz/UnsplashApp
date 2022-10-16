//
//  NetworkManager.swift
//  UnsplashApp
//
//  Created by Robert Miller on 13.10.2022.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager(NetworkService())
    
    init(_ networkService: NetworkServiceing) {
        self.networkService = networkService
    }
    
    private var networkService: NetworkServiceing
    lazy var page = 1
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: searchTerm, id: nil) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
    
    func fetchImageWithDetails(id: String, completion: @escaping (UnsplashPhoto?) -> ()) {
        networkService.request(searchTerm: nil, id: id) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: UnsplashPhoto.self, from: data)
            completion(decode)
        }
    }
    
    func fetchRandomImages(completion: @escaping ([UnsplashPhoto]?) -> ()) {
        networkService.request(searchTerm: nil, id: nil) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            completion(decode)
        }
    }
    
    func fetchAndCacheImage(unsplashPhoto: UnsplashPhoto, urlKind: URLKind, completion: @escaping (UIImage) -> ()) {
        let photoUrl = unsplashPhoto.urls[urlKind.rawValue]
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        guard let imagePlug = UIImage(systemName: "photo") else { return }
        let imageView = UIImageView()
        
        imageView.sd_setImage(with: url) { fetchedImage, _, _, _ in
            completion(imageView.image ?? imagePlug)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
