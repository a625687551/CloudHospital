//
//  Router.swift
//  CloudHospital
//
//  Created by wangankui on 11/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation
import Alamofire

enum Router {
    static let basrURL: String = "https://jsonplaceholder.typicode.com/"
    
    case get(Int?)
    case post([String: Any]?)
}

extension Router: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            case .post:
                return .post
            }
        }
        
        var params: [String: Any]? {
            switch self {
            case .get:
                return nil
            case .post(let params):
                return params
            }
        }
        
        var url: URL {
            var relativeURL: String = "todos"
            switch self {
            case .get(let id):
                if id != nil {
                    relativeURL = "todos/\(id!)"
                }
            case .post:
                relativeURL = "posts"
            }
            
            let url = URL(string: Router.basrURL)!.appendingPathComponent(relativeURL)
            return url
        }
        
        var HTTPHeaders: [String : String]? {
            var headers = [String : String]()
            switch self {
            case .get:
                break
            case .post:
                headers = [:]
            }
            return headers
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = HTTPHeaders
        let encoding = JSONEncoding.default
        
        return try encoding.encode(request, with: params)
    }
}
