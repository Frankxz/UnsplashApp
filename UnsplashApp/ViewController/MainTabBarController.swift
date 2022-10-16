//
//  MainTabBarController.swift
//  UnsplashApp
//
//  Created by Robert Miller on 12.10.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemBackground
        
        let photosVC = PhotosCollectionViewController(collectionViewLayout: WaterfallLayout())
        let favoritesVC = FavoritesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
            generateNavigationVC(viewController: photosVC, title: "Search", image: UIImage(systemName: "magnifyingglass")),
            generateNavigationVC(viewController: favoritesVC, title: "Favorite", image: UIImage(systemName: "heart"))
        ]
        
        AppUtility.lockOrientation(.portrait)
    }
    
    private func generateNavigationVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        navigationVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return navigationVC
    }
    
}
