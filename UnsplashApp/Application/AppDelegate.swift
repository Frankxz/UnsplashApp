//
//  AppDelegate.swift
//  UnsplashApp
//
//  Created by Robert Miller on 12.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainTabBarVC = MainTabBarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainTabBarVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
}

