//
//  RestApi.swift
//  
//
//  Created by PAN on 2021/2/25.
//

import Foundation

public protocol RestEndpoint {
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any] { get }
}
