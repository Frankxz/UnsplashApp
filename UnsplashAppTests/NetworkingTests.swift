//
//  UnsplashAppTests.swift
//  UnsplashAppTests
//
//  Created by Robert Miller on 12.10.2022.
//

import XCTest
@testable import UnsplashApp

class NetworkingTests: XCTestCase {
    
    let mockedNetworkService = NetworkService()
    
    // MARK: - URL Configuring tests
    func testURLConfiguringWithoutPath() throws {
        let url = mockedNetworkService.url(params: [:], path: URLPath.none.rawValue)
        XCTAssertEqual(url, URL(string: URLPath.fullPath))
    }
    
    func testURLConfiguringWithIncorrectPath() throws {
        let url = mockedNetworkService.url(params: [:], path: URLPath.incorrect.rawValue)
        XCTAssertEqual(url, URL(string:  URLPath.fullPath))
    }
    
    func testURLConfiguringWithPathForSearch() throws {
        let url = mockedNetworkService.url(params: [:], path: URLPath.searchPhoto.rawValue)
        XCTAssertEqual(url, URL(string: URLPath.fullPath + URLPath.searchPhoto.rawValue))
    }
    
    func testURLConfiguringWithPathForSearchRandom() throws {
        let url = mockedNetworkService.url(params: [:], path: URLPath.randomPhoto.rawValue)
        XCTAssertEqual(url, URL(string: URLPath.fullPath + URLPath.randomPhoto.rawValue))
    }
    
    func testURLConfiguringWithPathForSearchByID() throws {
        let url = mockedNetworkService.url(params: [:], path: URLPath.photoByID.rawValue)
        XCTAssertEqual(url, URL(string: URLPath.fullPath + URLPath.photoByID.rawValue))
    }
    
    // MARK: - API Access token test
    func testRequestAccesToken() throws {
        var request = mockedNetworkService.configureRequest(searchTerm: nil, id: nil)
        request.allHTTPHeaderFields = mockedNetworkService.prepareHeader()
        
        XCTAssertEqual(request.allHTTPHeaderFields, [
            "Authorization": "Client-ID wML3_h5mdIfYGeBzYWNVtkSgHsg3chU_t1AZ1sxPVoI"
        ])
    }
    
    // MARK: - Parameters configuring tests
    func testParametersConfiguringForSearch() throws {
        let request = mockedNetworkService.configureRequest(searchTerm: "bar", id: nil)
        var parameters = [String: String]()
        parameters["query"] = "bar"
        parameters["page"] = String(NetworkManager.shared.page)
        parameters["per_page"] = String(30)
        
        XCTAssertEqual(request.url?.queryParameters!, parameters)
    }
    
    func testParametersConfiguringForRandom() throws {
        let request = mockedNetworkService.configureRequest(searchTerm: nil, id: nil)
        var parameters = [String: String]()
        parameters["count"] = String(30)
        
        XCTAssertEqual(request.url?.queryParameters!, parameters)
    }
}


extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
