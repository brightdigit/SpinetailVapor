// swift-tools-version:5.2.0
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
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
    .package(url: "https://github.com/realm/SwiftLint", from: "0.43.0"), // dev
    .package(url: "https://github.com/shibapm/Rocket.git", from: "1.2.0"), // dev
    .package(path: "../Spinetail"),
    .package(path: "../PrchVapor")
  ],
  targets: [
    .target(name: "SpinetailVapor", dependencies: ["Spinetail", "PrchVapor"]),
  ]
)

#if canImport(PackageConfig)
  import PackageConfig

  let requiredCoverage: Int = 0

  let config = PackageConfiguration([
    "rocket": [
      "steps": [
        ["hide_dev_dependencies": ["package_path": "Package@swift-5.5.swift"]],
        "hide_dev_dependencies",
        "git_add",
        "commit",
        "tag",
        "unhide_dev_dependencies",
        ["unhide_dev_dependencies": ["package_path": "Package@swift-5.5.swift"]],
        "git_add",
        ["commit": ["message": "Unhide dev dependencies"]]
      ]
    ],
    "komondor": [
      "pre-commit": [
        "swift run swiftformat .",
        "swift run swiftlint autocorrect",
        // swiftlint:disable:next line_length
        // "swift run sourcedocs generate build --clean --reproducible-docs --all-modules",
        "git add .",
        "swift run swiftformat --lint .",
        "swift run swiftlint"
      ]
    ]
  ]).write()
#endif
