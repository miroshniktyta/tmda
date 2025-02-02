//
//  SceneDelegate.swift
//  tmda
//
//  Created by pc on 01.02.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        self.window = window
        window.makeKeyAndVisible()
    }
} 
