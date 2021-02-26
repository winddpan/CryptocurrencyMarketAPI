//
//  File.swift
//
//
//  Created by PAN on 2021/2/25.
//

import CryptocurrencyMarketAPI_Common
import Foundation
import RxSwift
import SwiftyJSON

public class FutureRestSession {
    private lazy var session = RestSession(baseUrl: URL(string: "https://fapi.binance.com")!, plugins: [BinanceRestPlugin(apiKey: self.apiKey, secretKey: self.secretKey)])
    public let apiKey: String
    public let secretKey: String

    required init(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }

    public func request(api: BinanceRestEndpoint) -> Single<JSON> {
        return session.request(api)
    }
}
