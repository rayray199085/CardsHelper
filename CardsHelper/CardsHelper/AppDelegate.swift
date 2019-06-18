//
//  AppDelegate.swift
//  CardsHelper
//
//  Created by Stephen Cao on 18/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupBasicSettings()
        window = UIWindow.initWindow(controllerName: "SCMainViewController")
        window?.backgroundColor = UIColor.white
        return true
    }
}
private extension AppDelegate{
    func setupBasicSettings(){
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
}

