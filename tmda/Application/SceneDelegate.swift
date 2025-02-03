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
        let httpClient = HTTPClient()
        let movieService = MovieService(client: httpClient)
        let viewModel = MoviesListViewModel(movieService: movieService)
        let viewController = MoviesListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        window.overrideUserInterfaceStyle = .dark
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
} 
