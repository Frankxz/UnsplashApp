//
//  String + Extension.swift
//  UnsplashApp
//
//  Created by Robert Miller on 15.10.2022.
//

import Foundation

extension String {
    func formatDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:self) ?? Date()
        return date.formatted()
    }
}
