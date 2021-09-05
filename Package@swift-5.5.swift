// swift-tools-version:5.5
// swiftlint:disable explicit_top_level_acl line_length
import PackageDescription

let package = Package(
  name: "SpinetailVapor",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v10),
    .tvOS(.v10),
    .watchOS(.v3)
  ],
  products: [
    .library(name: "SpinetailVapor", targets: ["SpinetailVapor"])
  ],
  dependencies: [
    .package(url: "https://github.com/shibapm/Komondor", from: "1.1.0"), // dev
    .package(url: "https://github.com/eneko/SourceDocs", from: "1.2.1"), // dev
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
    .package(url: "https://github.com/realm/SwiftLint", from: "0.43.0"), // dev
    .package(url: "https://github.com/shibapm/Rocket.git", from: "1.2.0"), // dev
    .package(url: "https://github.com/mattpolzin/swift-test-codecov", .branch("master")), // dev
    .package(url: "https://github.com/brightdigit/Spinetail", from: "0.1.0"),
    .package(url: "https://github.com/brightdigit/PrchVapor.git", from: "0.1.0")
  ],
  targets: [
    .target(name: "SpinetailVapor", dependencies: ["Spinetail", "PrchVapor"]),
    .executableTarget(name: "SpinetailVaporApp", dependencies: ["SpinetailVapor"]),
    .executableTarget(name: "SpinetailNIOApp", dependencies: ["PrchVapor", "Spinetail"])
  ]
)

#if canImport(PackageConfig)
  import PackageConfig

  let requiredCoverage: Int = 85

  let config = PackageConfiguration([
    "komondor": [
      "pre-push": [
        "swift test --enable-code-coverage --enable-test-discovery",
        // swiftlint:disable:next line_length
        "swift run swift-test-codecov .build/debug/codecov/SyndiKit.json --minimum \(requiredCoverage)"
      ],
      "pre-commit": [
        "swift test --enable-code-coverage --enable-test-discovery --generate-linuxmain",
        "swift run swiftformat .",
        "swift run swiftlint autocorrect",
        "swift run sourcedocs generate build --clean --reproducible-docs --all-modules",
        "git add .",
        "swift run swiftformat --lint .",
        "swift run swiftlint"
      ]
    ]
  ]).write()
#endif
