//
//  BaseNetwork.swift
//  CloudHospital
//
//  Created by wangankui on 26/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandler = ((_ request: BaseRequest, _ response: BaseResponse) -> ())

class BaseNetwork {
    static let shared = BaseNetwork()

    func load(_ urlString: String,
              with parameters: Parameters,
              originalRequest request: BaseRequest,
              _ completionHandler: @escaping CompletionHandler) {
        
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { response in
            
            print("-----------------------------")
            switch response.result {
            case .success(let json):
                let dict = json as! Dictionary<String, Any>
                
                let origin = dict["origin"] as! String
                let headers = dict["headers"] as! Dictionary<String, String>
                
                print("origin: \(origin)")
                let ua = headers["User-Agent"]
                print("UA: \(String(describing: ua))")
                
//                completionHandler(request, )

            case .failure(let error):
                print("\(error)")
//                completionHandler(request, response)
            }
            
            print("=============================")
            print(response)
        }
        
    }
}
