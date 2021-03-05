//
//  FutureWebsocket.swift
//
//
//  Created by PAN on 2021/2/24.
//

import CryptocurrencyMarketAPI_Common
import Foundation
import RxSwift
import SwiftyJSON

public class FutureWebsocket {
    private let webSocketEngine = WebSocketEngine(url: URL(string: "wss://fstream.binance.com/stream")!, pongInterval: .seconds(900))
    public let symbol: FutureSymbol
    private var subscribeSubjects: [String: PublishSubject<JSON>] = [:]
    private var subscribeCounters: [String: Int] = [:]

    public init(symbol: FutureSymbol) {
        self.symbol = symbol

        webSocketEngine.onEvent = { event in
            switch event {
            case let .text(text):
                if let data = text.data(using: .utf8), let json = try? JSON(data: data), let stream = json["stream"].string {
                    for (key, subject) in self.subscribeSubjects {
                        if key.hasPrefix("\(stream)_") {
                            if json["data"].dictionary != nil {
                                subject.onNext(json["data"])
                            } else {
                                subject.onNext(json)
                            }
                        }
                    }
                }
            default:
                return
            }
        }
    }

    public func subscribe<T: BinanceWebsocketStream>(_ stream: T) -> Observable<JSON> {
        let key = stream.streamName(symbol: symbol.rawValue) + "_" + stream.callbackEventName
        var subject: PublishSubject<JSON>
        if let old = subscribeSubjects[key] {
            subject = old
        } else {
            subject = PublishSubject<JSON>()
        }
        return subject
            .do(onSubscribe: { [weak self, weak subject] in
                guard let self = self, let subject = subject else { return }
                if self.subscribeSubjects[key] == nil {
                    self.subscribeWrite(stream.streamName(symbol: self.symbol.rawValue))
                    self.subscribeSubjects[key] = subject
                }
                self.subscribeCounters[key] = (self.subscribeCounters[key] ?? 0) + 1
            }, onDispose: { [weak self] in
                guard let self = self else { return }
                self.subscribeCounters[key] = (self.subscribeCounters[key] ?? 0) - 1
                if (self.subscribeCounters[key] ?? 0) <= 0 {
                    self.subscribeCounters.removeValue(forKey: key)
                    self.subscribeSubjects.removeValue(forKey: key)
                    self.unsubscribeWrite(stream.streamName(symbol: self.symbol.rawValue))
                }
            })
            .asObservable()
    }

    private func subscribeWrite(_ params: String) {
        let api = [
            "method": "SUBSCRIBE",
            "params": [params],
            "id": Int64(Date().timeIntervalSince1970 * 1000),
        ] as [String: Any]

        if let data = try? JSONSerialization.data(withJSONObject: api, options: []), let json = String(data: data, encoding: .utf8) {
            webSocketEngine.write(string: json)
        }
    }

    private func unsubscribeWrite(_ params: String) {
        let api = [
            "method": "UNSUBSCRIBE",
            "params": [params],
            "id": Int64(Date().timeIntervalSince1970 * 1000),
        ] as [String: Any]

        if let data = try? JSONSerialization.data(withJSONObject: api, options: []), let json = String(data: data, encoding: .utf8) {
            webSocketEngine.write(string: json)
        }
    }
}
