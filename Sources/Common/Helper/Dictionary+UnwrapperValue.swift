//
//  Dictionary+FilterNilValue.swift
//  AppFoundation
//
//  Created by PAN on 2021/1/26.
//  Copyright © 2021 YR. All rights reserved.
//

import Foundation

public extension Dictionary {
    func unwrapperValue<Wrapped>() -> [Key: Wrapped] where Value == Wrapped? {
        var result: [Key: Wrapped] = [:]
        for (key, value) in self {
            if let value = value {
                result[key] = value
            }
        }
        return result
    }
}
