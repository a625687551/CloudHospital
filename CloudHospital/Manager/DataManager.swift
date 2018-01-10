//
//  DataManager.swift
//  CloudHospital
//
//  Created by wangankui on 05/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation
import Alamofire

final class DataManager {
    private let baseURL : URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    static let shared = DataManager(baseURL: API.authenticatedURL)
    
    typealias CompletionHandler = (Any?, Error?) -> Void
    
    func start(parameters: [String: Any]?, completion: @escaping CompletionHandler) {        
        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    completion(value, nil)
                case .failure(let error):
                    completion(nil, error)
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
