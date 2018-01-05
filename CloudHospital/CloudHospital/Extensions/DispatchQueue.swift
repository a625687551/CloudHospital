//
//  DispatchQueue.swift
//  CloudHospital
//
//  Created by wangankui on 05/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation

extension DispatchQueue {
    func safeAsync(_ closure: @escaping () -> ()){
        if self === DispatchQueue.main && Thread.isMainThread {
            closure()
        } else {
            async { closure() }
        }
    }
}
