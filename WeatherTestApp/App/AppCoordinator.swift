//
//  AppCoordinator.swift
//  WeatherTestApp
//

import UIKit
import Foundation

final class AppCoordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {

        let vc = WeatherViewController()
        
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
    }
}
