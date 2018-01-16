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
    static let str = "http://yunuat.hsyuntai.com:8080/hsyt-yun-restapi/r/310000/80010/117"
    static let baseURL = URL(string: str)!
    static let authenticatedURL = baseURL//.appendingPathComponent(key)
    
    static let unicodeURLStr = "http://120.26.224.231:8080/hs-udb-resource/r/10001/100"
    static let unicodeURL = URL(string: unicodeURLStr)!
}

