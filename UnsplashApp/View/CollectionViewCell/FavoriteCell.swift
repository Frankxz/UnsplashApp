//
//  FavoriteCell.swift
//  UnsplashApp
//
//  Created by Robert Miller on 14.10.2022.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    static let reuseId = "PictureCell"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.updateAppearenceForCell()
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel.makeInfoLabel(size: 15, color: .label)
        label.textAlignment = .center
        return label
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            NetworkManager.shared.fetchAndCacheImage(unsplashPhoto: unsplashPhoto, urlKind: .regular) { [weak self] fetchedImage in
                self?.photoImageView.image = fetchedImage
                self?.authorLabel.text = self?.unsplashPhoto.user?.username
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

//  MARK: - UI
extension FavoriteCell {
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
    }
    
    private func setupConstraints() {
        addSubview(photoImageView)
        addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            //  photoImageView
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            
            //  authorLabel
            authorLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
