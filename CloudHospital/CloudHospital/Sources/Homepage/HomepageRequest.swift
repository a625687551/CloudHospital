//
//  HomepageRequest.swift
//  CloudHospital
//
//  Created by wangankui on 27/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import Foundation

struct HomepageRequestHelper {
    
    func app() {
        let request = BaseRequest(urlString: "https://httpbin.org/get")
        request.start { request, response in
            print("++++++++++++++++++++")
            print(request)
            print(response)
        }
    }
}

