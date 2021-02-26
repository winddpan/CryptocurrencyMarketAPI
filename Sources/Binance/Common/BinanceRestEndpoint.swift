//
//  File.swift
//  
//
//  Created by PAN on 2021/2/25.
//

import Foundation
import CryptocurrencyMarketAPI_Common

public protocol BinanceRestEndpoint: RestEndpoint {
    var needSignature: Bool { get }
}
