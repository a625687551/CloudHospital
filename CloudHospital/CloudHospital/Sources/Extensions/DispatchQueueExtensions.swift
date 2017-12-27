//
//  DispatchQueueExtensions.swift
//  CloudHospital
//
//  Created by wangankui on 27/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
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
