// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SecretRabbitCode",
    products: [
        .library(
            name: "SecretRabbitCode",
            targets: ["SecretRabbitCode"]
        )
    ],
    targets: [
        .target(
            name: "SecretRabbitCode",
            dependencies: ["CSamplerate"]
        ),
        .target(
            name: "CSamplerate",
            path: "libsamplerate",
            exclude: [
                "src/CMakeLists.txt",
                "src/check_asm.sh",
                "src/Version_script.in"
            ],
            sources: ["src"],
            publicHeadersPath: "include",
            cSettings: [
                .define("PACKAGE", to: "\"SecretRabbitCode\""),
                .define("VERSION", to: "\"1.0.0\""),
                .unsafeFlags(["-include", "stdbool.h"])
            ]
        ),
        .testTarget(
            name: "SecretRabbitCodeTests",
            dependencies: ["SecretRabbitCode"]
        ),
    ]
)