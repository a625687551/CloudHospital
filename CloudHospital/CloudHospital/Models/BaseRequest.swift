//
//  BaseRequest.swift
//  CloudHospital
//
//  Created by wangankui on 26/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import Foundation

class BaseRequest {
    let urlString: String
    let parameters: [String: Any]
    
    init(urlString: String, parameters: [String: Any] = [:]) {
        self.urlString = urlString
        self.parameters = parameters
    }
    
    func start(completionHandler: @escaping CompletionHandler) -> () {
        BaseNetwork.shared.load(self.urlString,
                                with: self.parameters,
                                originalRequest: self,
                                completionHandler)
    }
    
}
