//
//  AppDelegate.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-27.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // Setup URL cache
        CacheService.setup()

        return true
    }
}
