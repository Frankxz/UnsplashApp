//
//  OriginalImageViewController.swift
//  UnsplashApp
//
//  Created by Robert Miller on 15.10.2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var originalSizeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        setupNavigationBar()
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        view.addSubview(originalSizeImage)

        NSLayoutConstraint.activate([
            originalSizeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            originalSizeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            originalSizeImage.topAnchor.constraint(equalTo: view.topAnchor),
            originalSizeImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveAction)
        )
    }
    
    @objc private func saveAction() {
        guard let image = originalSizeImage.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageWillSave(_:_:_:)), nil)
    }
    
    @objc func imageWillSave(_ image: UIImage, _ error: Error?, _ contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(with: "Error while saving", and: error.localizedDescription)
        } else {
            showAlert(with: "Save successfully", and: "Image has been saved to your photo library.")
        }
    }
}

extension PhotoViewController {
    func showAlert(with title: String, and massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
