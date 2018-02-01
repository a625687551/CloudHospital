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
                                      "version": "2.2.2",
                                      "Accept": "application/json",
                                      "Content-Type": "application/json",
                                      "Host": "120.26.224.231:8080",
                                      "Accept-Language": "en;q=1",
                                      "Accept-Encoding": "gzip, deflate",
                                      "User-Agent": "hundsun_cloud_health/2.2.0 (iPhone; iOS 11.2; Scale/3.00)"]
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    
    static let shared = DataManager(baseURL: API.authenticatedURL)
    
    typealias CompletionHandler = (Any?, Error?) -> Void
    
    func start(parameters: [String: Any]?, completion: @escaping CompletionHandler) {
        
        unicodeRequest()
        
//        let date = Int(Date.init().timeIntervalSince1970 * 1000)
//        let rsaStr = Convert.rsa_public_encrypt(String(date))
//        headers!["signature"] = rsaStr
////        headers!["unicode"] = "9081ad35f0744c1289fe1f0451c407c0"
//        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .responseJSON { response in
//
//                switch response.result {
//                case .success(let value):
//                    self.handleResponse(value, completion: completion)
//                case .failure(let error):
//                    completion(nil, error)
//                }
//        }
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
        let date = Int(Date.init().timeIntervalSince1970 * 1000)
        let parameters: [String: Any]? = ["terminalTime": date,
                                          "devModel": "iPhone",
                                          "terminalType": 2]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let rsaStr = Convert.rsa_private_sign(jsonString)
                headers!["signature"] = rsaStr
            }
        } catch {
            
        }
        
        

        
        
        
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
