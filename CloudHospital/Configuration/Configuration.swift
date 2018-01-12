//
//  Configuration.swift
//  CloudHospital
//
//  Created by wangankui on 05/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation

struct API {
    static let key = ""
    // "https://httpbin.org/get"
    static let str = "http://yunuat.hsyuntai.com:8080/hsyt-yun-restapi/r/310000/80050/105"
    static let baseURL = URL(string: str)!
    static let authenticatedURL = baseURL//.appendingPathComponent(key)
}

