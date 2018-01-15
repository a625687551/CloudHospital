//
//  ResponseErrorKind.swift
//  CloudHospital
//
//  Created by wangankui on 15/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation

struct ResponseErrorKind {
    var productType: Int = 0
    var moudleType: Int = 00000
    var subModuleType: Int = 000
    var errorCode: Int = 000
    
    private func isPureInt(string: String) -> Bool {
        let scanner: Scanner = Scanner(string: string)
        var val: Int = 0
        return scanner.scanInt(&val) && scanner.isAtEnd
    }

    init?(_ kind: String) {
        guard kind.isEmpty else {
            return nil
        }
        
        guard !kind.isPureInt else {
            return nil
        }
        
        if kind.count == 4 {
            errorCode = Int(kind)!
            
        } else if kind.count == 15 {
            // 61 00 10000 100 003
            let nsKind = kind as NSString
            productType = Int(nsKind.substring(with: NSMakeRange(3, 1)))!
            moudleType = Int(nsKind.substring(with: NSMakeRange(4, 5)))!
            subModuleType = Int(nsKind.substring(with: NSMakeRange(9, 3)))!
            errorCode = Int(nsKind.substring(with: NSMakeRange(12, 3)))!
        }
    }
}


