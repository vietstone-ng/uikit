//
//  SceneDelegate.swift
//  Onboarding
//
//  Created by Viet Nguyen Tran on 22/08/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        window.rootViewController = OnboardingVC.new()
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
}
