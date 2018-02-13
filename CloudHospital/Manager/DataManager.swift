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
import KeychainAccess

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
        // obtaining an item
        let keychain = Keychain(service: "com.cloudhospital.session")
        if let unicode = try? keychain.get("unicode") {
            headers!["unicode"] = unicode
        }
        
        let date = Int(Date.init().timeIntervalSince1970 * 1000)
        let rsaStr = Convert.rsa_public_encrypt(String(date))
        headers!["signature"] = rsaStr
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
        let date = Int(Date.init().timeIntervalSince1970 * 1000)
        let parameters: [String: Any]? = ["terminalTime": date,
                                          "devModel": "iPhone",
                                          "terminalType": 2]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let nsString = jsonString as NSString
                let string = nsString.substring(with: NSMakeRange(1, nsString.length - 2)) as NSString
                let componets = string.components(separatedBy: ",") as [NSString]
            
                let array = ["pushToken","terminalTime","devModel","imei","terminalType","mac","ipAddress"] as [NSString]
                let tempArray: NSMutableArray = NSMutableArray()
                for key in array {
                    for str in componets {
                        let strRange = str.range(of: key as String)
                        if (strRange.location == 1 && strRange.length == key.length) {
                            tempArray.add(str)
                            break
                        }
                    }
                }
                
                var value = ""
                if (tempArray.count > 0) {
                    value = tempArray.componentsJoined(by: ",")
                }
                var body = "{}"
                if (value.count > 0) {
                    body = "{\(value)}"
                }
                
                let rsaStr = Convert.rsa_private_sign(body)
                headers!["signature"] = rsaStr
            }
            
        } catch {
            print(error)
        }
        
        Alamofire.request(API.unicodeURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                if let unicode = json["data"]["unicode"].string {
                    // save item to keychain
                    let keychain = Keychain(service: "com.cloudhospital.session")
                    do {
                        try keychain.set(unicode, key: "unicode")
                    } catch {
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
