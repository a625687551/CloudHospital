//
//  HomepageModel.swift
//  CloudHospital
//
//  Created by wangankui on 28/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HomepageModel {
    var args: [String: Any]?
    var headers: [String: Any]?
    
    var origin: String?
    var url: String?
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}


extension HomepageModel {
//    init?(json: [String: Any]) {
//        guard let args = json["args"] as? String,
//            let headers = json["headers"] as? [String: Any],
//            let origin = json["origin"] as? String,
//            let url = json["url"] as? String
//            else {
//                return nil
//        }
//
//        self.args = args
//        self.headers = headers
//        self.origin = origin
//        self.url = url
//    }
    
    init(json: [String: Any]) throws {
        guard let args = json["args"] as? [String: Any] else {
            throw SerializationError.missing("args")
        }
        
        guard let headers = json["headers"] as? [String: Any] else {
            throw SerializationError.missing("headers")
        }
        
        guard let origin = json["origin"] as? String else {
            throw SerializationError.missing("origin")
        }
        
        guard let url = json["url"] as? String else {
            throw SerializationError.missing("url")
        }
        
        self.args = args
        self.headers = headers
        self.origin = origin
        self.url = url
    }
}

extension HomepageModel {
    static func homepage(parameters: [String: Any], completion: @escaping (HomepageModel) -> Void) {
        let request = BaseRequest(urlString: "https://httpbin.org/get")
        request.start { request, response in
            let homepage = try? HomepageModel(json: response as! [String : Any])
            completion(homepage!)
            
            print("++++++++++++++++++++")
            print(request)
            print(response)
        }
    }
}
