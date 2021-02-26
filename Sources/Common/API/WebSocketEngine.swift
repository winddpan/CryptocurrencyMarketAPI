//
//  File.swift
//
//
//  Created by PAN on 2021/2/24.
//

import Foundation
import Starscream

open class WebSocketEngine: WebSocketDelegate {
    public enum PongInterval {
        case never
        case respondToPingWithPong
        case seconds(TimeInterval)
    }

    public let url: URL
    open var pongInterval: PongInterval

    open var onEvent: ((WebSocketEvent) -> Void)?
    private let socket: WebSocket
    private var lastPongDate = Date(timeIntervalSince1970: 0)

    public required init(url: URL, pongInterval: PongInterval = .never) {
        self.url = url
        self.pongInterval = pongInterval

        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.callbackQueue = DispatchQueue(label: "com.cyptocurrencyMarketAPI.socket")
        socket.onEvent = onEvent
        socket.respondToPingWithPong = false
        socket.delegate = self
        socket.connect()
    }

    public func write(data: Data, completion: (() -> Void)? = nil) {
        socket.write(data: data, completion: completion)
    }

    public func write(string: String, completion: (() -> Void)? = nil) {
        socket.write(string: string, completion: completion)
    }

    open func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .ping:
            switch pongInterval {
            case .never:
                break
            case .respondToPingWithPong:
                lastPongDate = Date()
                client.write(pong: Data())
            case let .seconds(seconds):
                if Date().timeIntervalSince1970 - lastPongDate.timeIntervalSince1970 >= seconds {
                    lastPongDate = Date()
                    client.write(pong: Data())
                }
            }
        default:
            break
        }
    }
}
