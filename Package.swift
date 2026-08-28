// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-buffer-slab",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Buffer Slab Primitive", targets: ["Buffer Slab Primitive"]),
        .library(name: "Buffer Slab Bounded Primitive", targets: ["Buffer Slab Bounded Primitive"]),
        .library(name: "Buffer Slab Inline Primitive", targets: ["Buffer Slab Inline Primitive"]),
        .library(name: "Buffer Slab Small Primitive", targets: ["Buffer Slab Small Primitive"]),
        .library(name: "Buffer Slab", targets: ["Buffer Slab"]),
        .library(name: "Buffer Slab Bounded", targets: ["Buffer Slab Bounded"]),
        .library(name: "Buffer Slab Inline", targets: ["Buffer Slab Inline"]),
        .library(name: "Buffer Slab Small", targets: ["Buffer Slab Small"]),
        .library(name: "Buffer Slab Test Support", targets: ["Buffer Slab Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-buffer.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-growth.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-storage.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-index.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-affine.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ordinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-memory.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-sequence.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-iterator.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-pair.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-property.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ownership.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-memory-inline.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-bit-vector.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-memory-allocation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-memory-small.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-storage-memory.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-ordinal-comparison.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-property-ownership.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Buffer Slab Primitive",
            dependencies: [
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Allocator Primitive", package: "swift-memory-allocation"),
                .product(name: "Memory Allocator Protocol", package: "swift-memory-allocation"),
                .product(name: "Memory Inline", package: "swift-memory-inline"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Bit Vector Bounded", package: "swift-bit-vector"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Affine Standard Library Integration", package: "swift-affine"),
                .product(name: "Ordinal Standard Library Integration", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal-comparison"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),
        .target(
            name: "Buffer Slab Bounded Primitive",
            dependencies: [
                "Buffer Slab Primitive",
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Allocator Primitive", package: "swift-memory-allocation"),
                .product(name: "Memory Allocator Protocol", package: "swift-memory-allocation"),
                .product(name: "Memory Inline", package: "swift-memory-inline"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Bit Vector Bounded", package: "swift-bit-vector"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Affine Standard Library Integration", package: "swift-affine"),
                .product(name: "Ordinal Standard Library Integration", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal-comparison"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),
        .target(
            name: "Buffer Slab Inline Primitive",
            dependencies: [
                "Buffer Slab Primitive",
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Inline", package: "swift-memory-inline"),
                .product(name: "Bit Vector Static", package: "swift-bit-vector"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Affine Standard Library Integration", package: "swift-affine"),
                .product(name: "Ordinal Standard Library Integration", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal-comparison"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),
        .target(
            name: "Buffer Slab Small Primitive",
            dependencies: [
                "Buffer Slab Primitive",
                "Buffer Slab Inline Primitive",
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Allocator Primitive", package: "swift-memory-allocation"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Memory Inline", package: "swift-memory-inline"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Affine Standard Library Integration", package: "swift-affine"),
                .product(name: "Ordinal Standard Library Integration", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal-comparison"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),
        .target(
            name: "Buffer Slab",
            dependencies: [
                "Buffer Slab Primitive",
                "Buffer Slab Bounded",
                "Buffer Slab Inline",
                "Buffer Slab Small",
                .product(name: "Sequence", package: "swift-sequence"),
            ]
        ),
        .target(
            name: "Buffer Slab Bounded",
            dependencies: [
                "Buffer Slab Bounded Primitive",
                .product(name: "Sequence", package: "swift-sequence"),
            ]
        ),
        .target(
            name: "Buffer Slab Inline",
            dependencies: [
                "Buffer Slab Inline Primitive",
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Affine Standard Library Integration", package: "swift-affine"),
                .product(name: "Ordinal Standard Library Integration", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Buffer Slab Small",
            dependencies: [
                "Buffer Slab Small Primitive",
                "Buffer Slab Primitive",
                "Buffer Slab Inline",
                .product(name: "Sequence", package: "swift-sequence"),
            ]
        ),
        .target(
            name: "Buffer Slab Test Support",
            dependencies: [
                "Buffer Slab",
                "Buffer Slab Bounded",
                "Buffer Slab Inline",
                "Buffer Slab Small",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Allocator Primitive", package: "swift-memory-allocation"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(
                    name: "Cardinal Standard Library Integration",
                    package: "swift-cardinal"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(
                    name: "Tagged Standard Library Integration",
                    package: "swift-tagged"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Bit Vector Bounded", package: "swift-bit-vector"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Buffer Slab Tests",
            dependencies: ["Buffer Slab", "Buffer Slab Test Support"]
        ),
        .testTarget(
            name: "Buffer Slab Bounded Tests",
            dependencies: ["Buffer Slab Bounded", "Buffer Slab Test Support"]
        ),
        .testTarget(
            name: "Buffer Slab Inline Tests",
            dependencies: ["Buffer Slab Inline", "Buffer Slab Test Support"]
        ),
        .testTarget(
            name: "Buffer Slab Small Tests",
            dependencies: ["Buffer Slab Small", "Buffer Slab Test Support"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("BuiltinModule"),
        .enableExperimentalFeature("RawLayout"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
