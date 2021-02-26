//
//  File.swift
//
//
//  Created by PAN on 2021/2/24.
//

import Foundation

public enum KlineIntreval {
    case _1m
    case _3m
    case _5m
    case _15m
    case _30m
    case _1h
    case _2h
    case _4h
    case _6h
    case _8h
    case _12h
    case _1d
    case _3d
    case _1w
    case _1M

    var symbol: String {
        return String(describing: self).replacingOccurrences(of: "_", with: "")
    }
}

public enum ContractType {
    /// 永续合约
    case perpetual
    /// 当月交割合约
    case current_month
    /// 次月交割合约
    case next_month

    var symbol: String {
        return String(describing: self).uppercased()
    }
}

public enum FutureSymbol: String {
    case btcusdt
    case ethusdt
}

public enum CurrencySymbol: String {
    case btcusdt
    case ethusdt
}
