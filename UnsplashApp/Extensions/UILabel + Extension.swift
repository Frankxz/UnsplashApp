//
//  UILabel + Extension.swift
//  UnsplashApp
//
//  Created by Robert Miller on 12.10.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont?, textColor: UIColor) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    static func makeTitleLable(title: String) -> UILabel {
        UILabel(text: title, font: UIFont(name: "ChalkboardSE-Regular", size: 24), textColor: .label)
    }
    
    static func makeInfoLabel(size: CGFloat, color: UIColor) -> UILabel{
        let label = UILabel(text: "", font: UIFont(name: "ChalkboardSE-Regular", size: size), textColor: color)
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
