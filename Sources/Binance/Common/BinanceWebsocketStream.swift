//
//  Stream.swift
//
//
//  Created by PAN on 2021/2/24.
//

import Foundation

public protocol BinanceWebsocketStream {
    func streamName(symbol: String) -> String
    var callbackEventName: String { get }
}
