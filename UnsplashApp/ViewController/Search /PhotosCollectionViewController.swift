//
//  PhotosCollectionViewController.swift
//  UnsplashApp
//
//  Created by Robert Miller on 12.10.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    private lazy var layoutButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),style: .plain,
                        target: self, action: #selector(refreshButtonTapped))
    }()
    
    
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private let searchController = UISearchController()
    
    private let detailViewController = DetailViewController()
    
    private var photos = [UnsplashPhoto]()
    
    private var timer: Timer?
    
    private var isAnimated = false
    private var isFetched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isFetched) { fetchRandomImages() }
    }
    
    @objc func refreshButtonTapped() {
        fetchRandomImages()
        isAnimated = false
    }
    
}

// MARK: - UI
extension PhotosCollectionViewController {
    
    private func setupNavigationBar() {
        let titleLabel = UILabel.makeTitleLable(title: "Pictures")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = layoutButton
        navigationItem.setBackButton()
        
        setupSearchController()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.placeholder = "Search photos by keyword"
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.reuseId)
       
        if let customLayout = collectionViewLayout as? WaterfallLayout {
            customLayout.delegate = self
        }
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // If scrolled to the last row -> loading more data
        if indexPath.row == photos.count - 1 { loadMore() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseId, for: indexPath) as! PictureCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PictureCell
        
        guard let image = cell.photoImageView.image else { return }
        let ID = cell.unsplashPhoto.id
        
        detailViewController.prepareForPush(image: image, id: ID)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - CustomCollectionViewLayout
extension PhotosCollectionViewController: CustomCollectionViewLayoutDelegate {
    
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        return CGSize(width: photo.width, height: photo.height)
    }
    
}

// MARK: - Unsplash data
extension PhotosCollectionViewController {
    
    func fetchRandomImages() {
        clearData()
        NetworkManager.shared.fetchRandomImages () { [weak self] randomPhotos in
            guard let fetchedPhotos = randomPhotos else { return }
            self?.spinner.stopAnimating()
            self?.photos = fetchedPhotos
            self?.collectionView.reloadData()
            self?.isFetched = true
        }
    }
    
    func loadMore() {
        if (photos.count > StorageManager.cacheLimitNumber) { StorageManager.clearMemory() }
        guard let searchText = searchController.searchBar.text else { return }
        
        // Check what to upload:
        if (!searchText.isEmpty) {
            NetworkManager.shared.page += 1
            NetworkManager.shared.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos.append(contentsOf: fetchedPhotos.results)
                self?.collectionView.reloadData()
            }
        } else {
            NetworkManager.shared.fetchRandomImages () { [weak self] randomPhotos in
                guard let fetchedPhotos = randomPhotos else { return }
                self?.photos.append(contentsOf: fetchedPhotos)
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func clearData(){
        photos = []
        collectionView.reloadData()
        spinner.startAnimating()
        isAnimated = false
        
        StorageManager.clearMemory()
    }
}

// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        clearData()
        
        //  Since the API has a limit of 50 requests per hour, we minimize unnecessary requests
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            NetworkManager.shared.page = 1
            NetworkManager.shared.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                
                self?.spinner.stopAnimating()
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
            if(searchText.isEmpty) { self.fetchRandomImages() }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchRandomImages()
    }
}

// MARK: - Animation
extension PhotosCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isAnimated { return }
        if indexPath.row > 18 { return}
        UIView.makeAlphaAnimate(elements: [cell], duration: 0.4, delay: (0.05 * Double(indexPath.row)))
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isAnimated = true
    }
    
}


