//
//  File.swift
//
//
//  Created by PAN on 2021/2/25.
//

import CryptocurrencyMarketAPI_Common
import CryptoKit
import Foundation

class BinanceRestPlugin: RestPlugin {
    let apiKey: String
    let secretKey: String

    required init(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }

    func prepare(_ request: URLRequest, api: RestEndpoint) -> URLRequest {
        guard let api = api as? BinanceRestEndpoint, let url = request.url, var urlCompons = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return request
        }
        var request = request
        if api.needSignature {
            let key = SymmetricKey(data: secretKey.data(using: .utf8)!)
            let string = urlCompons.query ?? ""
            let signature = HMAC<SHA256>.authenticationCode(for: string.data(using: .utf8)!, using: key)
            let signatureStr = Data(signature).map { String(format: "%02hhx", $0) }.joined()

            var queryItems = urlCompons.queryItems ?? []
            queryItems.append(URLQueryItem(name: "signature", value: signatureStr))
            urlCompons.queryItems = queryItems

            var newHeaders = request.allHTTPHeaderFields ?? [:]
            newHeaders["X-MBX-APIKEY"] = apiKey

            request.allHTTPHeaderFields = newHeaders
            request.url = urlCompons.url
        }
        return request
    }

    func process(_ result: (Data?, URLResponse?, Error?)) -> (Data?, URLResponse?, Error?) {
        return result
    }
}
