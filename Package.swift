// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CryptocurrencyMarketAPI",
    platforms: [.iOS(.v13), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CryptocurrencyMarketAPI-Binance",
            targets: ["CryptocurrencyMarketAPI-Binance"]
        ),
        .library(
            name: "CryptocurrencyMarketAPI-Huobi",
            targets: ["CryptocurrencyMarketAPI-Huobi"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/daltoniam/Starscream", from: "4.0.4"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CryptocurrencyMarketAPI-Common",
            dependencies: ["Starscream",
                           "SwiftyJSON",
                           "RxSwift"],
            path: "Sources/Common"
        ),
        .target(
            name: "CryptocurrencyMarketAPI-Binance",
            dependencies: ["CryptocurrencyMarketAPI-Common"],
            path: "Sources/Binance"
        ),
        .target(
            name: "CryptocurrencyMarketAPI-Huobi",
            dependencies: ["CryptocurrencyMarketAPI-Common"],
            path: "Sources/Huobi"
        ),
        .testTarget(
            name: "CryptocurrencyMarketAPITests",
            dependencies: ["CryptocurrencyMarketAPI-Binance", "CryptocurrencyMarketAPI-Huobi"]
        ),
    ]
)
