//
//  DetailViewController.swift
//  UnsplashApp
//
//  Created by Robert Miller on 12.10.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var infoView = InfoView()
    
    private let imageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var unsplashPhoto: UnsplashPhoto? {
        didSet {
            //  Asynchronously loading a higher quality image
            guard let unsplashPhoto = unsplashPhoto else { return }
            NetworkManager.shared.fetchAndCacheImage(unsplashPhoto: unsplashPhoto,
                                                     urlKind: .regular) { [weak self] fetchedImage in
                self?.imageView.image = fetchedImage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.setBackButton()
        infoView.delegate = self
        generateConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.makeAlphaAnimate(elements: [imageView], duration: 0.6, delay: 0)
    }
    
    func prepareForPush(image: UIImage, id: String) {
        imageView.image = nil
        infoView.prepareInfoView()
        NetworkManager.shared.fetchImageWithDetails(id: id) { [weak self] (detailResults) in
            guard let fetchedPhoto = detailResults else { return }
            self?.imageView.image = image // Setup already fetched image of small quality to avoid flickers and waiting
            self?.updateDetailView(unsplashPhoto: fetchedPhoto)
        }
    }
    
    private func updateDetailView(unsplashPhoto: UnsplashPhoto) {
        self.unsplashPhoto = unsplashPhoto
        infoView.updateInfoView(unsplashPhoto: unsplashPhoto)
    }
}


//MARK: - UI + constraints
extension DetailViewController {
    private func generateConstraints() {
        view.addSubview(imageView)
        view.addSubview(infoView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false

        setupImageViewConstraints()
        setupInfoViewConstraints()
    }
    
    
    private func setupImageViewConstraints(){
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.8),
        ])
    }
    
    private func setupInfoViewConstraints() {
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

// MARK: - InfoViewDelegate
extension DetailViewController: InfoViewDelegate {
    
    func showSizeButtonTapped() {
        let photoVC = PhotoViewController()
        photoVC.originalSizeImage.image = imageView.image
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    func actionButtonTapped() {
        let shareController = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController, animated: true, completion: nil)
    }
}
