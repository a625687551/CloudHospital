//
//  DataManager.swift
//  CloudHospital
//
//  Created by wangankui on 05/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class DataManager {
    private let baseURL : URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    static let shared = DataManager(baseURL: API.authenticatedURL)
    
    typealias CompletionHandler = (Any?, Error?) -> Void
    
    func start(parameters: [String: Any]?, completion: @escaping CompletionHandler) {
        let headers: [String: String]? = ["prdCode": "YUN-000001",
                                          "client_id": "440000@310000",
                                          "terminalType": "2",
                                          "version": "2.2.0",
                                          "Accept": "application/json",
                                          "Content-Type": "application/json",
                                          "Host": "gd.hsyuntai.com:8663",
                                          "User-Agent": "hundsun_cloud_health/2.2.0 (iPhone; iOS 11.2; Scale/3.00)",
                                          "Accept-Language": "en;q=1"
//                                          "unicode": "e5b8d55ad2204ff98449cd0fa0ebcf7d",
//                                          "signature": "m7KRLW34xDBQNn7nw/PQqQ/CqEmRmgJhQwwI0661n/oPvprz/oWEwqZHkLB0eKBqDAaEqmG9YnkegQS1bEKxQfXcE9aeTXXh8NngSJd25rTYXmXsuxLTcvqYuX8P8PJVuOUqEPBGJeQ9LCzwe0sHgBIBy2V8Vv1LlPP4EbD7+N4="
                                          ]
        
        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in

                switch response.result {
                case .success(let value):
                    self.handleResponse(value, completion: completion)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    
    
    private func handleResponse(_ response: Any, completion: CompletionHandler) {
        let json = JSON(response)
        if json["result"].boolValue {
            completion(json, nil)
        } else {
            guard let kind = json["kind"].string as? String else {
                return
            }
            
            let erroeKind = ResponseErrorKind(kind)
            
            
            completion(nil, nil)
        }
    }
    
    
    
    
    func dataAt(parameters: [String: Any]?, completion: @escaping CompletionHandler) {
        var request = URLRequest(url: baseURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.didFinishGetData(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    func didFinishGetData(data: Data?, response: URLResponse?, error: Error?, completion: CompletionHandler) {
//        if let _ = error {
//            completion(nil, .failedRequest)
//        }
//        else if let data = data, let response = response as? HTTPURLResponse {
//            if response.statusCode == 200 {
//                do {
//                    let decoder = JSONDecoder()
//                    let homepage = try decoder.decode(Homepage.self, from: data)
//                    completion(homepage, nil)
//                } catch {
//                    completion(nil, .invalidResponse)
//                }
//            }
//            else {
//                completion(nil, .failedRequest)
//            }
//        }
//        else {
//            completion(nil, .unknown)
//        }
    }
}
