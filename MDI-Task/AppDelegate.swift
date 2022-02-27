//
//  AppDelegate.swift
//  MDI-Task
//
//  Created by Ahmed Zaghloul on 27/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let vm = CurrencyConversionVM(dataSource: RemoteDataSource())
        let rootVC = CurrencyConversionVC(viewModel: vm)
        let navigationViewController = UINavigationController(rootViewController: rootVC)

        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

