//
//  UIView + extension.swift
//  UnsplashApp
//
//  Created by Robert Miller on 15.10.2022.
//

import UIKit

extension UIView {
    
  static func makeAlphaAnimate(elements: [UIView], duration: TimeInterval, delay: TimeInterval){
        elements.forEach(){ $0.alpha = 0}
     
        UIView.animate(withDuration: duration, delay: delay) { 
            elements.forEach(){ $0.alpha = 1 }
        }
    }
}
