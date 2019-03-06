//
//  AppDelegate.swift
//  Multithreading
//
//  Created by Kirill Khudiakov on 06/03/2019.
//  Copyright © 2019 Kirill Khudiakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        let mainViewController = MainViewController()
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        return true
    }

}

