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
    private var baseURL : URL
    
    var headers: [String: String]? = ["prdCode": "YUN-000001",
                                      "client_id": "440000@310000",
                                      "terminalType": "2",
                                      "version": "2.2.0",
                                      "Accept": "application/json",
                                      "Content-Type": "application/json",
                                      "Host": "120.26.224.231:8080",
                                      "Accept-Language": "en;q=1",
                                      "User-Agent": "hundsun_cloud_health/2.2.0 (iPhone; iOS 11.2; Scale/3.00)"]
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    
    static let shared = DataManager(baseURL: API.authenticatedURL)
    
    typealias CompletionHandler = (Any?, Error?) -> Void
    
    func start(parameters: [String: Any]?, completion: @escaping CompletionHandler) {
        
        unicodeRequest()
        
        headers!["signature"] = "m7KRLW34xDBQNn7nw/PQqQ/P2WtBrW7guKXJEElGszz8qyU/UpQu5NPml/t5zKGxuuJ+bWjHVg7xRf+e4PqIqzIaXgm+vRah01VU1wejmAke/8l/8G64eP8UmDQVmIPWpUzpnbz7hcgni3ImSxfhccOYpd8KJqKQjs+wxN1AcaqkVgS3SERKWrn+DU/kn2r63w="
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
            guard let kind = json["kind"].string else { return }
            guard let errorKind = ResponseErrorKind(kind) else { return }
            
            if errorKind.moudleType == 10000 {
                switch errorKind.errorCode {
                case 3, 4, 7:
                    unicodeRequest()
                    
                default:
                    break
                }
            }
            
            completion(nil, nil)
        }
    }
    
    func unicodeRequest() {
        headers!["signature"] = "m7KRLW34xDBQNn7nw/PQqQ/P2WtBrW7guKXJEElGszz8qyU/UpQu5NPml/t5zKGxuuJ+bWjHVg7xRf+e4PqIqzIaXgm+vRah01VU1wejmAke/8l/8G64eP8UmDQVmIPWpUzpnbz7hcgni3ImSxfhccOYpd8KJqKQjs+wxN1AcaqkVgS3SERKWrn+DU/kn2r63w="
        let date = Date.init().timeIntervalSince1970 * 1000
        let parameters: [String: Any]? = ["terminalTime": date,
                                          "devModel": "iPhone",
                                          "terminalType": 2]
        
        Alamofire.request(API.unicodeURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
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
