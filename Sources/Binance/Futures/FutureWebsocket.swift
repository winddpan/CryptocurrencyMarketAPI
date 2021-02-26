//
//  FutureWebsocket.swift
//
//
//  Created by PAN on 2021/2/24.
//

import CryptocurrencyMarketAPI_Common
import Foundation
import RxCocoa
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
                let json = JSON(text)
                guard let e = json["e"].string else {
                    return
                }
                for (key, subject) in self.subscribeSubjects {
                    if key.hasSuffix("_\(e)") {
                        subject.onNext(json)
                    }
                }
            default:
                return
            }
        }
    }

    public func subscribe<T: BinanceWebsocketStream>(_ stream: T) -> Signal<JSON> {
        let key = stream.streamName(symbol: symbol.rawValue) + "_" + stream.callbackEventName
        if let old = subscribeSubjects[key] {
            return old.asSignal { _ in Signal<JSON>.empty() }
        } else {
            DispatchQueue.main.async {
                self.webSocketEngine.write(string: stream.streamName(symbol: self.symbol.rawValue))
            }

            let new = PublishSubject<JSON>()
            return new
                .do(onSubscribe: { [weak self, weak new] in
                    guard let self = self, let new = new else { return }
                    let count = self.subscribeCounters[key] ?? 0
                    self.subscribeSubjects[key] = new
                    self.subscribeCounters[key] = count + 1
                }, onDispose: { [weak self] in
                    guard let self = self else { return }
                    let count = self.subscribeCounters[key] ?? 0
                    if count <= 0 {
                        self.subscribeCounters.removeValue(forKey: key)
                        self.subscribeSubjects.removeValue(forKey: key)
                    }
                })
                .asSignal { _ in Signal<JSON>.empty() }
        }
    }
}
