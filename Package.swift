// swift-tools-version:5.7
// swiftlint:disable explicit_top_level_acl line_length
import PackageDescription

let package = Package(
  name: "SpinetailVapor",
  platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)],
  products: [
    .library(name: "SpinetailVapor", targets: ["SpinetailVapor"])
  ],
  dependencies: [
    .package(url: "https://github.com/brightdigit/Spinetail.git", from: "1.0.0-alpha.1"),
    .package(url: "https://github.com/brightdigit/PrchVapor.git", from: "1.0.0-alpha.1")
  ],
  targets: [
    .target(name: "SpinetailVapor", dependencies: ["Spinetail", "PrchVapor"])
  ]
)
