//
//  File.swift
//
//
//  Created by PAN on 2021/2/24.
//

import Foundation

public enum FutureStream: BinanceWebsocketStream {
    case aggregateTrade
    case markPrice
    case kline(KlineIntreval)
    case continuousContractKline(ContractType, KlineIntreval)
    case miniTicker
    case ticker
    case bookTicker
    case liquidationOrder
    case partialBookDepth(Int)
    case diffBookDepth
    case tokenNav
    case navKline(KlineIntreval)

    public func streamName(symbol: String) -> String {
        switch self {
        case .aggregateTrade:
            return "\(symbol)@aggTrade"
        case .markPrice:
            return "\(symbol)@markPrice@1s"
        case let .kline(interval):
            return "\(symbol)@kline_\(interval.symbol)"
        case let .continuousContractKline(contractType, interval):
            return "\(symbol)_\(contractType.symbol)@kline_\(interval.symbol)"
        case .miniTicker:
            return "\(symbol)@miniTicker"
        case .ticker:
            return "\(symbol)@ticker"
        case .bookTicker:
            return "\(symbol)@bookTicker"
        case .liquidationOrder:
            return "\(symbol)@forceOrder"
        case let .partialBookDepth(level):
            return "\(symbol)>@depth\(level)@100ms"
        case .diffBookDepth:
            return "\(symbol)>@depth@100ms"
        case .tokenNav:
            return "\(symbol)@tokenNav"
        case let .navKline(interval):
            return "\(symbol)@nav_Kline_\(interval.symbol)"
        }
    }

    public var callbackEventName: String {
        switch self {
        case .aggregateTrade:
            return "aggTrade"
        case .markPrice:
            return "markPriceUpdate"
        case .kline:
            return "kline"
        case .continuousContractKline:
            return "continuous_kline"
        case .miniTicker:
            return "24hrMiniTicker"
        case .ticker:
            return "24hrTicker"
        case .bookTicker:
            return "bookTicker"
        case .liquidationOrder:
            return "forceOrder"
        case .partialBookDepth:
            return "depthUpdate"
        case .diffBookDepth:
            return "depthUpdate"
        case .tokenNav:
            return "nav"
        case .navKline:
            return "kline"
        }
    }
}
