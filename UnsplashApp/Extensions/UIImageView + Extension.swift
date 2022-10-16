//
//  UIImage + Extension.swift
//  UnsplashApp
//
//  Created by Robert Miller on 16.10.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func updateAppearenceForCell(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        contentMode = .scaleAspectFill
        layer.cornerRadius = 10
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
