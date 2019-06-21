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
extension SCNetworkManager{
    func getMetadata(completion:@escaping (_ dict: [String: Any]? ,_ isSuccess: Bool)->()){
        guard let region = UserDefaults.standard.object(forKey: "region") as? String else{
            completion(nil,false)
            return
        }
        let urlString = "https://\(region).api.blizzard.com/hearthstone/metadata"
        let params = ["locale": "en_US"]
        requestWithToken(urlString: urlString, method: HTTPMethod.get, params: params) { (res, isSuccess) in
            let dict = res as? [String: Any]
            completion(dict, isSuccess)
        }
    }
}
extension SCNetworkManager{
    func getCards(params: [String: String], completion:@escaping (_ dict: [String: Any]? ,_ isSuccess: Bool)->()){
        guard let region = UserDefaults.standard.object(forKey: "region") as? String else{
            completion(nil,false)
            return
        }
        let urlString = "https://\(region).api.blizzard.com/hearthstone/cards?locale=en_US"
        requestWithToken(urlString: urlString, method: HTTPMethod.get, params: params) { (res, isSuccess) in
            let dict = res as? [String: Any]
            completion(dict, isSuccess)
        }
    }
    
    func getCardImage(imageUrlString: String, completion:@escaping (_ image: UIImage?)->()){
        guard let url = URL(string: imageUrlString) else{
            completion(nil)
            return
        }
        UIImage.downloadImage(url: url) { (image) in
            completion(image)
        }
    }
}


