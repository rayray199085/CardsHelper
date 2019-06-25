//
//  SCMainViewController.swift
//  WowLittleHelper
//
//  Created by Stephen Cao on 16/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SCMainViewController: UITabBarController {
    
    private lazy var composeButton: UIButton = UIButton.imageButton(
        withNormalImageName: "compose_button_normal",
        andWithHighlightedImageName: "compose_button_highlighted")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HelperCommonValues.SCBaseViewBackgroundColor
        setupChildControllers()
        tabBar.barTintColor = HelperCommonValues.SCNaviBarColor
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginNotification), name:
            NSNotification.Name(HelperCommonValues.SCUserShouldLoginNotification), object: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(HelperCommonValues.SCUserShouldLoginNotification), object: nil)
    }
    
    @objc private func handleLoginNotification(notification: Notification){
        let nav = UINavigationController(rootViewController: SCOAuthViewController())
        nav.navigationBar.barTintColor = HelperCommonValues.SCNaviBarColor
        nav.navigationBar.isTranslucent = false
        present(nav, animated: true, completion: nil)
    }
}
private extension SCMainViewController{
    
    /// setup child controllers by initializing an array of dictionary
    func setupChildControllers(){
        guard let path = Bundle.main.path(forResource: "main", ofType: "json"),
             let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else{
                return
        }
        var childControllers = [UIViewController]()
        for dict in array{
            childControllers.append(getController(dict: dict))
        }
        viewControllers = childControllers
    }
    
    /// get child controllers
    ///
    /// - Parameter dict: dictionary contains titile, class and tab bar image
    /// - Returns: child controller
    func getController(dict: [String: Any])->UIViewController{
        guard let clsName = dict["clsName"] as? String,
              let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type,
              let title = dict["title"] as? String,
              let imageName = dict["imageName"] as? String else{
                return UIViewController()
        }
        let vc = cls.init()
        vc.title = title
        let normalImageName = "tabbar_\(imageName)"
        vc.tabBarItem.image = UIImage(named: normalImageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(
            named: normalImageName + "_selected")?.withRenderingMode(
                UIImage.RenderingMode.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor : HelperCommonValues.SCNaviBarTintColor],
            for: UIControl.State.highlighted)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font: UIFont(name: "OPTIBelwe-Medium", size: 11)!], for: [])
        if let visitorInfo = dict["visitorInfo"] as? [String: String]{
            if vc.isKind(of: SCBaseViewController.self){
                (vc as! SCBaseViewController).visitorInfo = visitorInfo
            }
        }
        let nav = SCNavigationViewController(rootViewController: vc)
        return nav
    }
}
