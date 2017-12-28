//
//  BaseNetwork.swift
//  CloudHospital
//
//  Created by wangankui on 26/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias CompletionHandler = ((_ request: BaseRequest, _ response: Any) -> ())

class BaseNetwork {
    static let shared = BaseNetwork()

    func load(_ urlString: String,
              with parameters: Parameters,
              originalRequest request: BaseRequest,
              _ completionHandler: @escaping CompletionHandler) {
        
        Alamofire.request(urlString, method: .get, parameters: parameters)
            .responseJSON { response in
                
            switch response.result {
            case .success(let value):
                completionHandler(request, value)
            case .failure(let error):
                completionHandler(request, error)
            }
        }
    }
}
