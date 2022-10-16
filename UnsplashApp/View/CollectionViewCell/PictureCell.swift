//
//  PhotoCollectionViewCell.swift
//  UnsplashApp
//
//  Created by Robert Miller on 12.10.2022.
//

import UIKit
import SDWebImage

class PictureCell: UICollectionViewCell {
    
    static let reuseId = "PictureCell"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.updateAppearenceForCell()
        return imageView
    }()
    
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            NetworkManager.shared.fetchAndCacheImage(unsplashPhoto: unsplashPhoto, urlKind: .small) { [weak self] fetchedImage in
                self?.photoImageView.image = fetchedImage
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}


// MARK: - Constraints
extension PictureCell {
    private func setupConstraints() {
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
