//
//  NetworkService.swift
//  UnsplashApp
//
//  Created by Robert Miller on 13.10.2022.
//

import Foundation

protocol NetworkServiceing {
    func request(searchTerm: String?, id: String?, completion: @escaping (Data?, Error?) -> Void)
    func configureRequest(searchTerm: String?, id: String?) -> URLRequest
    
    func prepareHeader() -> [String: String]?
    func prepareParamsForSearch(searchTerm: String?) -> [String: String]
    func prepareParamsForRandom() -> [String: String]
    
    func url(params: [String: String], path: String) -> URL
    func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask
}

class NetworkService: NetworkServiceing {
    
    func request(searchTerm: String?, id: String?, completion: @escaping (Data?, Error?) -> Void)  {
        let request = configureRequest(searchTerm: searchTerm, id: id)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
//MARK: -  Configuring data request by URL
    func configureRequest(searchTerm: String?, id: String?) -> URLRequest  {
        
        var parameters: [String: String] = [:]
        var url: URL
        
        //  If we did not receive ID  we configure request for search images by search term
        if (id == nil && searchTerm != nil) {
            parameters = self.prepareParamsForSearch(searchTerm: searchTerm)
            url = self.url(params: parameters, path: URLPath.searchPhoto.rawValue)
        }
        //  If we did not receive search term we configure request for search image by id
        else  if (searchTerm == nil && id != nil) {
            url = self.url(params: parameters, path: "/photos/\(id!)")
        }
        //  If both function parameters is nil or  by mistake not nil we configure request for search random images
        else {
            parameters = self.prepareParamsForRandom()
            url = self.url(params: parameters, path: URLPath.randomPhoto.rawValue)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        
        return request
    }
    
    
    internal func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID wML3_h5mdIfYGeBzYWNVtkSgHsg3chU_t1AZ1sxPVoI"
        
        return headers
    }
    
    //  Подготовка параметров для получения фотографий в поиске
    internal func prepareParamsForSearch(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(NetworkManager.shared.page)
        parameters["per_page"] = String(30)
        return parameters
    }
    
    //  Подготовка параметров для получения детальной информации
    internal func prepareParamsForRandom() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(30)
        return parameters
    }
    
    
    
    internal func url(params: [String: String], path: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = path
      
        if(!params.isEmpty) {
            components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        }
        
        return (components.url ?? URL(string: URLPath.fullPath)!)
    }
    
    internal func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

//https://api.unsplash.com/photos/XIkC1xERozw?client_id=wML3_h5mdIfYGeBzYWNVtkSgHsg3chU_t1AZ1sxPVoI

