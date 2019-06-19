//
//  SCNetworkManager+extension.swift
//  WowLittleHelper
//
//  Created by Stephen Cao on 15/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
enum SCItemImageSize {
    case small
    case large
}
extension SCNetworkManager{
    func getAccessToken(code: String,completion:@escaping (_ isSuccess: Bool)->()){
        guard let region = UserDefaults.standard.object(forKey: "region") as? String else{
            return
        }
        let urlString = "https://\(region).battle.net/oauth/token"
        let params = ["client_id": HelperCommonValues.SCClientId,
                      "client_secret": HelperCommonValues.SCClientSecret,
                      "grant_type": "authorization_code",
                      "code":code,
                      "redirect_uri": HelperCommonValues.SCRedirectURL]
       
        request(urlString: urlString, method: HTTPMethod.post, params: params) { [weak self](res, isSuccess, statusCode, error) in
            guard let tokenDict = res as? [String: Any] else{
                completion(false)
                return
            }
            self?.userAccount.yy_modelSet(with: tokenDict)
            self?.userAccount.saveUserInfo()
            SVProgressHUD.showInfo(withStatus: "Login Success!")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                completion(isSuccess)
            })
        }
    }
}


