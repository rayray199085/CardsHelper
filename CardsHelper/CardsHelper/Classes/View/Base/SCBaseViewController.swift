//
//  SCBaseViewController.swift
//  WowLittleHelper
//
//  Created by Stephen Cao on 18/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import DropDown

class SCBaseViewController: UIViewController {
    var userView: UIView?
    var visitorInfo : [String : String]?
    private lazy var userDefault = UserDefaults.standard
    private lazy var dropDown = DropDown()
    private var regionName = "us"
    private var selectedRegion = "🇺🇸US"{
        didSet{
            switch selectedRegion {
            case "🇺🇸US":
                regionName = "us"
            case "🇪🇺EU":
                regionName = "eu"
            case "🇦🇺APAC":
                regionName = "apac"
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        SCNetworkManager.shared.userLogon ? loadData() :()
        NotificationCenter.default.addObserver(self, selector: #selector(successLogin), name: NSNotification.Name(HelperCommonValues.SCUserSuccessLoginNotification), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(HelperCommonValues.SCUserSuccessLoginNotification), object: self)
    }
    @objc func loadData(){
        
    }
    @objc private func region(){
        dropDown.show()
    }
}
extension SCBaseViewController{
    
    @objc private func login(){
        NotificationCenter.default.post(name: NSNotification.Name(HelperCommonValues.SCUserShouldLoginNotification), object: nil)
    }

    @objc private func successLogin(){
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        view = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(HelperCommonValues.SCUserSuccessLoginNotification), object: nil)
    }
}

// MARK: - setup UI
extension SCBaseViewController{
    @objc private func setupUI(){
        SCNetworkManager.shared.userLogon ? setupUserView() : setupVisitorView()
    }
    
    @objc func setupUserView(){
        userView = UIView(frame: view.bounds)
        userView?.backgroundColor = HelperCommonValues.SCBaseViewBackgroundColor
        guard let naviBar = navigationController?.navigationBar else {
            return
        }
        view.insertSubview(userView!, belowSubview: naviBar)
        
    }
    
    private func setupVisitorView(){
        let visitiorView = SCVisitorView.visitorView()
        visitiorView.visitorInfo = visitorInfo
        guard let naviBar = navigationController?.navigationBar else {
            return
        }
        view.insertSubview(visitiorView, belowSubview: naviBar)
        naviBar.tintColor = HelperCommonValues.SCNaviBarTintColor
        let loginBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItem.Style.plain, target: self, action: #selector(login))
      
        let regionBarButtonItem = UIBarButtonItem(title: "🇺🇸US", target: self, action: #selector(region))
        navigationItem.rightBarButtonItem = loginBarButtonItem
        navigationItem.leftBarButtonItem = regionBarButtonItem
        // init region value is us
        userDefault.set(regionName, forKey: "region")
        dropDown.anchorView = regionBarButtonItem
        dropDown.textColor = HelperCommonValues.SCNaviBarTintColor
        dropDown.backgroundColor = HelperCommonValues.SCNaviBarColor
        dropDown.cornerRadius = 10.0
        dropDown.selectionBackgroundColor = UIColor.lightGray
        dropDown.dataSource = ["🇺🇸US", "🇪🇺EU", "🇦🇺APAC"]
        dropDown.width = 100
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            guard let btn = regionBarButtonItem.customView as? UIButton else{
                return
            }
            self.selectedRegion = item
            self.userDefault.set(self.regionName, forKey: "region")
            btn.setTitle(item, for: [])
            btn.sizeToFit()
        }
    }
}
