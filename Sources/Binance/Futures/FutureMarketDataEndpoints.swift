//
//  File.swift
//
//
//  Created by PAN on 2021/2/25.
//

import CryptocurrencyMarketAPI_Common
import Foundation

public enum FutureMarketDataEndpoints {
    /// 测试服务器连通性 PING
    case ping

    /// 获取服务器时间
    case time

    /// 获取交易规则和交易对
    case exchangeInfo

    /// 深度信息
    /// limit - 默认 500; 可选值:[5, 10, 20, 50, 100, 500, 1000]
    case depth(symbol: FutureSymbol, limit: Int?)

    /// 近期成交
    /// limit - 默认:500，最大1000
    case trades(symbol: FutureSymbol, limit: Int?)

    /// 查询历史成交(MARKET_DATA)
    /// limit - 默认值:500 最大值:1000
    case historicalTrades(symbol: FutureSymbol, limit: Int?, fromId: Int64?)

    /// 近期成交(归集)
    case aggTrades(symbol: FutureSymbol, fromId: Int64?, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// K线数据
    /// limit - 默认值:500 最大值:1500
    case klines(symbol: FutureSymbol, interval: KlineIntreval, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 连续合约K线数据
    /// limit - 默认值:500 最大值:1500
    case continuousKlines(symbol: FutureSymbol, contractType: ContractType, interval: KlineIntreval, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 最新标记价格和资金费率
    case premiumIndex(symbol: FutureSymbol?)

    /// 查询资金费率历史
    /// limit - 默认值:100 最大值:1000
    case fundingRate(symbol: FutureSymbol, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 24hr价格变动情况
    case _24hr(symbol: FutureSymbol?)

    /// 最新价格
    case price(symbol: FutureSymbol?)

    /// 当前最优挂单
    case bookTicker(symbol: FutureSymbol?)

    /// 获取市场强平订单
    case allForceOrders(symbol: FutureSymbol?, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 获取未平仓合约数
    case openInterest(symbol: FutureSymbol)

    /// 合约持仓量
    /// period - "5m","15m","30m","1h","2h","4h","6h","12h","1d"
    /// limit - default 30, max 500
    case openInterestHist(symbol: FutureSymbol, period: String, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 大户账户数多空比
    /// period - "5m","15m","30m","1h","2h","4h","6h","12h","1d"
    /// limit - default 30, max 500
    case topLongShortAccountRatio(symbol: FutureSymbol, period: String, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 大户持仓量多空比
    /// period - "5m","15m","30m","1h","2h","4h","6h","12h","1d"
    /// limit - default 30, max 500
    case topLongShortPositionRatio(symbol: FutureSymbol, period: String, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 多空持仓人数比
    /// period - "5m","15m","30m","1h","2h","4h","6h","12h","1d"
    /// limit - default 30, max 500
    case globalLongShortAccountRatio(symbol: FutureSymbol, period: String, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 合约主动买卖量
    /// period - "5m","15m","30m","1h","2h","4h","6h","12h","1d"
    /// limit - default 30, max 500
    case takerlongshortRatio(symbol: FutureSymbol, period: String, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 杠杆代币历史净值K线
    /// symbol - token name, e.g. "BTCDOWN", "BTCUP"
    /// limit - 默认值:500 最大值:1500
    case lvtKlines(symbol: String, interval: KlineIntreval, startTime: Int64?, endTime: Int64?, limit: Int?)

    /// 综合指数交易对信息
    case indexInfo(symbol: FutureSymbol?)
}

extension FutureMarketDataEndpoints: BinanceRestEndpoint {
    public var method: String {
        return "GET"
    }
    
    public var needSignature: Bool {
        return false
    }

    public var path: String {
        switch self {
        case .ping:
            return "/fapi/v1/ping"
        case .time:
            return "/fapi/v1/time"
        case .exchangeInfo:
            return "/fapi/v1/exchangeInfo"
        case .depth:
            return "/fapi/v1/depth"
        case .trades:
            return "/fapi/v1/trades"
        case .historicalTrades:
            return "/fapi/v1/historicalTrades"
        case .aggTrades:
            return "/fapi/v1/aggTrades"
        case .klines:
            return "/fapi/v1/klines"
        case .continuousKlines:
            return "/fapi/v1/continuousKlines"
        case .premiumIndex:
            return "/fapi/v1/premiumIndex"
        case .fundingRate:
            return "/fapi/v1/fundingRate"
        case ._24hr:
            return "/fapi/v1/ticker/24hr"
        case .price:
            return "/fapi/v1/ticker/price"
        case .bookTicker:
            return "/fapi/v1/ticker/bookTicker"
        case .allForceOrders:
            return "/fapi/v1/allForceOrders"
        case .openInterest:
            return "/fapi/v1/openInterest"
        case .openInterestHist:
            return "/fapi/v1/openInterestHist"
        case .topLongShortAccountRatio:
            return "/futures/data/topLongShortAccountRatio"
        case .topLongShortPositionRatio:
            return "/futures/data/topLongShortPositionRatio"
        case .globalLongShortAccountRatio:
            return "/futures/data/globalLongShortAccountRatio"
        case .takerlongshortRatio:
            return "/futures/data/takerlongshortRatio"
        case .lvtKlines:
            return "/fapi/v1/lvtKlines"
        case .indexInfo:
            return "/fapi/v1/indexInfo"
        }
    }

    public var parameters: [String: Any] {
        switch self {
        case .ping:
            return [:]
        case .time:
            return [:]
        case .exchangeInfo:
            return [:]
        case let .depth(symbol: symbol, limit: limit):
            return ["symbol": symbol,
                    "limit": limit].unwrapperValue()
        case let .trades(symbol: symbol, limit: limit):
            return ["symbol": symbol,
                    "limit": limit].unwrapperValue()
        case let .historicalTrades(symbol: symbol, limit: limit, fromId: fromId):
            return ["symbol": symbol,
                    "fromId": fromId,
                    "limit": limit].unwrapperValue()
        case let .aggTrades(symbol: symbol, fromId: fromId, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "fromId": fromId,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .klines(symbol: symbol, interval: interval, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "interval": interval.symbol,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .continuousKlines(symbol: symbol, contractType: contractType, interval: interval, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "contractType": contractType.symbol,
                    "interval": interval.symbol,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .premiumIndex(symbol: symbol):
            return ["symbol": symbol].unwrapperValue()
        case let .fundingRate(symbol: symbol, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let ._24hr(symbol: symbol):
            return ["symbol": symbol].unwrapperValue()
        case let .price(symbol: symbol):
            return ["symbol": symbol].unwrapperValue()
        case let .bookTicker(symbol: symbol):
            return ["symbol": symbol].unwrapperValue()
        case let .allForceOrders(symbol: symbol, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .openInterest(symbol: symbol):
            return ["symbol": symbol].unwrapperValue()
        case let .openInterestHist(symbol: symbol, period: period, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "period": period,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .topLongShortAccountRatio(symbol: symbol, period: period, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "period": period,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .topLongShortPositionRatio(symbol: symbol, period: period, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "period": period,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .globalLongShortAccountRatio(symbol: symbol, period: period, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "period": period,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .takerlongshortRatio(symbol: symbol, period: period, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "period": period,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .lvtKlines(symbol: symbol, interval: interval, startTime: startTime, endTime: endTime, limit: limit):
            return ["symbol": symbol,
                    "interval": interval.symbol,
                    "startTime": startTime,
                    "endTime": endTime,
                    "limit": limit].unwrapperValue()
        case let .indexInfo(symbol: symbol):
            return ["symbol": symbol].unwrapperValue()
        }
    }
}
