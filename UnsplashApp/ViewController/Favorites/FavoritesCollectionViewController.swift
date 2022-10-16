//
//  FavoritesCollectionViewController.swift
//  UnsplashApp
//
//  Created by Robert Miller on 12.10.2022.
//

import UIKit

class FavoritesCollectionViewController: UICollectionViewController {
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    
    private let detailViewController = DetailViewController()
    
    private var photos: [UnsplashPhoto] = []
    
    private var isNeedAnimate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setCollectionView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photos = StorageManager.fetchFavoritesList()
        isNeedAnimate = true
        collectionView.reloadData()
    }
}


// MARK: - View configuring
extension FavoritesCollectionViewController {
    private func setCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseId)
        
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel.makeTitleLable(title: "Favorites")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.setBackButton()
        
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FavoriteCell
        let ID = cell.unsplashPhoto.id
        guard let image = cell.photoImageView.image else { return }
        
        detailViewController.prepareForPush(image: image, id: ID)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}

// MARK: - Animation
extension FavoritesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isNeedAnimate { return }
        if indexPath.row > 18 { return}
        UIView.makeAlphaAnimate(elements: [cell], duration: 0.4, delay: (0.05 * Double(indexPath.row)))
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isNeedAnimate = false
    }
}
