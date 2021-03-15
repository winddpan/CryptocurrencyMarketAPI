//
///  File.swift
//
//
///  Created by PAN on 2021/2/25.
//

import Foundation

public protocol FutureOrder {
    func endpointParameters() -> [String: Any]
}

public extension FutureOrder {
    func endpointParameters() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map { (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }.compactMap { $0 })
        return dict
    }
}

///// 双向持仓模式
// public struct FutureDualSideOrder: FutureOrder {
//    /// STRING  YES 交易对
//    let symbol: String
//
//    /// ENUM    YES 买卖方向 SELL, BUY
//    let side: String
//
//    /// ENUM    NO  持仓方向，单向持仓模式下非必填，默认且仅可填BOTH;在双向持仓模式下必填,且仅可选择 LONG 或 SHORT
//    let positionSide: String
//
//    /// ENUM    YES 订单类型 LIMIT, MARKET, STOP, TAKE_PROFIT, STOP_MARKET, TAKE_PROFIT_MARKET, TRAILING_STOP_MARKET
//    let type: String
//
//    /// STRING  NO  true, false; 非双开模式下默认false；双开模式下不接受此参数； 使用closePosition不支持此参数。
//    let reduceOnly: String
//
//    /// DECIMAL NO  下单数量,使用closePosition不支持此参数。
//    let quantity: Decimal?
//
//    /// DECIMAL NO  委托价格
//    let price: Decimal?
//
//    /// STRING  NO  用户自定义的订单号，不可以重复出现在挂单中。如空缺系统会自动赋值。必须满足正则规则 ^[\.A-Z\:/a-z0-9_-]{1,36}$
//    let newClientOrderId: String?
//
//    /// DECIMAL NO  触发价, 仅 STOP, STOP_MARKET, TAKE_PROFIT, TAKE_PROFIT_MARKET 需要此参数
//    let stopPrice: Decimal?
//
//    /// STRING  NO  true, false；触发后全部平仓，仅支持STOP_MARKET和TAKE_PROFIT_MARKET；不与quantity合用；自带只平仓效果，不与reduceOnly 合用
//    let closePosition: String?
//
//    /// DECIMAL NO  追踪止损激活价格，仅TRAILING_STOP_MARKET 需要此参数, 默认为下单当前市场价格(支持不同workingType)
//    let activationPrice: Decimal?
//
//    /// DECIMAL NO  追踪止损回调比例，可取值范围[0.1, 5],其中 1代表1% ,仅TRAILING_STOP_MARKET 需要此参数
//    let callbackRate: Decimal?
//
//    /// ENUM    NO  有效方法
//    let timeInForce: String?
//
//    /// ENUM    NO  stopPrice 触发类型: MARK_PRICE(标记价格), CONTRACT_PRICE(合约最新价). 默认 CONTRACT_PRICE
//    let workingType: String?
//
//    /// STRING  NO  条件单触发保护："TRUE","FALSE", 默认"FALSE". 仅 STOP, STOP_MARKET, TAKE_PROFIT, TAKE_PROFIT_MARKET 需要此参数
//    let priceProtect: String?
//
//    /// ENUM    NO  "ACK", "RESULT", 默认 "ACK"
//    let newOrderRespType: String?
//
//    /// LONG    NO
//    let recvWindow: Int64?
//
//    /// LONG    YES
//    let timestamp: Int64
//
//    /// 限价单
//    init(limit symbol: FutureSymbol, quantity:  Decimal) {
//        positionSide = "BOTH"
//    }
// }

public struct FutureSingleSideOrder: FutureOrder {
    public enum Side: String {
        case buy
        case sell
    }

    /// STRING  YES 交易对
    let symbol: String

    /// ENUM    YES 买卖方向 SELL, BUY
    let side: String

    /// ENUM    YES 订单类型 LIMIT, MARKET, STOP, TAKE_PROFIT, STOP_MARKET, TAKE_PROFIT_MARKET, TRAILING_STOP_MARKET
    let type: String

    /// STRING  NO  true, false; 非双开模式下默认false；双开模式下不接受此参数； 使用closePosition不支持此参数。
    let reduceOnly: String?

    /// DECIMAL NO  下单数量,使用closePosition不支持此参数。
    let quantity: Decimal?

    /// DECIMAL NO  委托价格
    let price: Decimal?
    
    /// STRING  NO  用户自定义的订单号，不可以重复出现在挂单中。如空缺系统会自动赋值。必须满足正则规则 ^[\.A-Z\:/a-z0-9_-]{1,36}$
    let newClientOrderId: String?

    /// 限价单
    public init(limit symbol: FutureSymbol, side: Side, price: Decimal, quantity: Decimal, reduceOnly: Bool? = nil, newClientOrderId: String? = nil) {
        type = "LIMIT"
        self.price = price
        self.quantity = quantity
        self.symbol = symbol.rawValue
        self.side = side.rawValue.uppercased()
        self.reduceOnly = reduceOnly?.stringValue
        self.newClientOrderId = newClientOrderId
    }

    /// 市价单
    public init(market symbol: FutureSymbol, side: Side, quantity: Decimal, newClientOrderId: String? = nil) {
        type = "MARKET"
        price = nil
        self.quantity = quantity
        self.symbol = symbol.rawValue
        self.side = side.rawValue.uppercased()
        self.newClientOrderId = newClientOrderId
        reduceOnly = nil
    }
}

public enum FutureAccountTradesEndpoints {
    /// 下单 (TRADE)
    case order(FutureOrder)

    /// 批量下单 (TRADE) - 最多支持5个订单
    case batchOrders([FutureOrder])

    /// 撤销订单 (TRADE)
    case cancelOrder(FutureSymbol, orderId: Int64)

    /// 撤销全部订单 (TRADE)
    case cancelAllOrders(FutureSymbol)

    /// 批量撤销订单 (TRADE)
    case calcelBatchOrders(FutureSymbol, orderIds: [Int64])

    /// 查询当前挂单 (USER_DATA)
    case queryOpenOrder(FutureSymbol, orderId: Int64)

    /// 查看当前全部挂单 (USER_DATA)
    case queryAllOpenOrder(FutureSymbol)

    /// 查询订单 (USER_DATA)
    case queryOrder(FutureSymbol, orderId: Int64)

    /// 查询所有订单(包括历史订单) (USER_DATA)
    case queryAllOrder(FutureSymbol)

    /// 账户余额V2 (USER_DATA)
    case accountBalance

    /// 账户信息V2 (USER_DATA)
    case account

    /// 调整开仓杠杆 (TRADE) - 目标杠杆倍数：1 到 125 整数
    case leverage(FutureSymbol, leverage: Int)

    /// listenKey - POST:生成listenKey  PUT:延长listenKey有效期  DELETE:关闭listenKey
    case listenKey(String)
}

extension FutureAccountTradesEndpoints: BinanceRestEndpoint {
    public var method: String {
        switch self {
        case let .listenKey(method):
            return method
        default:
            return "GET"
        }
    }

    public var needSignature: Bool {
        return true
    }

    public var path: String {
        switch self {
        case .order:
            return "/fapi/v1/order"
        case .batchOrders:
            return "/fapi/v1/batchOrders"
        case .cancelOrder:
            return "/fapi/v1/order"
        case .cancelAllOrders:
            return "/fapi/v1/allOpenOrders"
        case .calcelBatchOrders:
            return "/fapi/v1/batchOrders"
        case .queryOpenOrder:
            return "/fapi/v1/openOrder"
        case .queryAllOpenOrder:
            return "/fapi/v1/openOrders"
        case .queryOrder:
            return "/fapi/v1/order"
        case .queryAllOrder:
            return "/fapi/v1/allOrders"
        case .accountBalance:
            return "/fapi/v2/balance"
        case .account:
            return "/fapi/v2/account"
        case .leverage:
            return "/fapi/v1/leverage"
        case .listenKey:
            return "/fapi/v1/listenKey"
        }
    }

    public var parameters: [String: Any] {
        switch self {
        case let .order(order):
            return order.endpointParameters().withTimestamp()
        case let .batchOrders(orders):
            return ["batchOrders": orders.map { $0.endpointParameters() }].withTimestamp()
        case let .cancelOrder(symbol, orderId: orderId):
            return ["symbol": symbol.rawValue,
                    "orderId": orderId].withTimestamp()
        case let .cancelAllOrders(symbol):
            return ["symbol": symbol.rawValue].withTimestamp()
        case let .calcelBatchOrders(symbol, orderIds: orderIds):
            return ["symbol": symbol.rawValue,
                    "orderIdList": orderIds].withTimestamp()
        case let .queryOpenOrder(symbol, orderId: orderId):
            return ["symbol": symbol.rawValue,
                    "orderId": orderId].withTimestamp()
        case let .queryAllOpenOrder(symbol):
            return ["symbol": symbol.rawValue].withTimestamp()
        case let .queryOrder(symbol, orderId: orderId):
            return ["symbol": symbol.rawValue,
                    "orderId": orderId].withTimestamp()
        case let .queryAllOrder(symbol):
            return ["symbol": symbol.rawValue].withTimestamp()
        case .accountBalance:
            return [:].withTimestamp()
        case .account:
            return [:].withTimestamp()
        case let .leverage(symbol, leverage: leverage):
            return ["symbol": symbol.rawValue,
                    "leverage": leverage].withTimestamp()
        case .listenKey:
            return [:]
        }
    }
}

private extension Dictionary where Key == String, Value == Any {
    func withTimestamp() -> [String: Any] {
        var param = self
        param["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000)
        return param
    }
}
