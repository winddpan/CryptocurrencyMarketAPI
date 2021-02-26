//
//  File.swift
//  
//
//  Created by PAN on 2021/2/26.
//

import Foundation

public extension Bool {
    var stringValue: String {
        if self {
            return "true"
        }
        return "false"
    }
}
