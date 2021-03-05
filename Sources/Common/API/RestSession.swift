//
//  RestEngine.swift
//
//
//  Created by PAN on 2021/2/24.
//

import Foundation
import RxSwift
import SwiftyJSON

public protocol RestPlugin {
    func prepare(_ request: URLRequest, api: RestEndpoint) -> URLRequest
    func process(_ result: (Data?, URLResponse?, Error?)) -> (Data?, URLResponse?, Error?)
}

open class RestSession {
    public let baseUrl: URL
    public let plugins: [RestPlugin]

    public required init(baseUrl: URL, plugins: [RestPlugin] = []) {
        self.baseUrl = baseUrl
        self.plugins = plugins
    }

    public func request(_ api: RestEndpoint) -> Single<JSON> {
        var urlCompos = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        urlCompos.path = api.path.hasPrefix("/") ? api.path : "/\(api.path)"
        urlCompos.queryItems = api.parameters.compactMap { (key, value) -> URLQueryItem? in
            URLQueryItem(name: key, value: "\(value)")
        }
        var request = URLRequest(url: urlCompos.url!)
        request.timeoutInterval = 5
        request.httpMethod = api.method

        for plugin in plugins {
            request = plugin.prepare(request, api: api)
        }

        weak var weakSelf = self
        return Single<JSON>.create { (single) -> Disposable in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let self = weakSelf else { return }
                var data = data
                var response = response
                var error = error

                for plugin in self.plugins {
                    (data, response, error) = plugin.process((data, response, error))
                }

                if let data = data {
                    do {
                        let json = try JSON(data: data)
                        single(.success(json))
                    } catch {
                        single(.failure(error))
                    }
                } else if let error = error {
                    single(.failure(error))
                } else {
                    single(.failure(NSError(domain: "unexpected error", code: 0, userInfo: nil)))
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
