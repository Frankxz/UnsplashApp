//
//  UIButton + Extention.swift
//  UnsplashApp
//
//  Created by Robert Miller on 16.10.2022.
//

import UIKit

extension UIButton {
    func setupAppearence(image: UIImage?, title: String?){
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        
        layer.cornerRadius = 20
        backgroundColor = .secondarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 18)
    }
}
