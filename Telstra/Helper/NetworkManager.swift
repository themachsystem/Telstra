//
//  NetworkManager.swift
//  Telstra
//
//  Created by suitecontrol on 30/3/20.
//  Copyright © 2020 suitecontrol. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias completionBlock = (_ jsonResponse: Dictionary<String, Any>?, _ error: String?) -> Void

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    func runDataTask(url: String, completionHandler: @escaping completionBlock) {
        AF.request(url).responseString { response in
            switch response.result {
            case .success(let jsonString):
                let data = jsonString.data(using: .utf8)!
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                    {
                        completionHandler(json, nil)
                    } else {
                        completionHandler(nil,"unable to parse json string")
                    }
                } catch let error as NSError {
                    print(error)
                }
            case .failure(let error):
                completionHandler(nil, error.errorDescription)
            }
        }
    }
}
