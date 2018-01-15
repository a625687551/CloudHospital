//
//  String.swift
//  CloudHospital
//
//  Created by wangankui on 15/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation

extension String {
    var isPureInt: Bool {
        let scanner: Scanner = Scanner(string: self)
        var val: Int = 0
        return scanner.scanInt(&val) && scanner.isAtEnd
    }
}
