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
        .library(
            name: "Buffer Slab Bounded",
            targets: ["Buffer Slab Bounded"]
        ),
        .library(name: "Buffer Slab Inline", targets: ["Buffer Slab Inline"]),
        .library(name: "Buffer Slab Small", targets: ["Buffer Slab Small"]),
        .library(
            name: "Buffer Slab Test Support",
            targets: ["Buffer Slab Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-memory-inline.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-growth.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-bit-vector.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-finite.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-sequence.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-pair.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-heap.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-small.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Buffer Slab Primitive",
            dependencies: [
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Inline",
                    package: "swift-memory-inline"
                ),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(
                    name: "Bit Vector Bounded",
                    package: "swift-bit-vector"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Buffer Slab Bounded Primitive",
            dependencies: [
                "Buffer Slab Primitive",
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Inline",
                    package: "swift-memory-inline"
                ),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(
                    name: "Bit Vector Bounded",
                    package: "swift-bit-vector"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Buffer Slab Inline Primitive",
            dependencies: [
                "Buffer Slab Primitive",
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Inline",
                    package: "swift-memory-inline"
                ),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(name: "Store Inline", package: "swift-storage"),
                .product(
                    name: "Bit Vector Static",
                    package: "swift-bit-vector"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Finite Bounded", package: "swift-finite"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Buffer Slab Small Primitive",
            dependencies: [
                "Buffer Slab Primitive",
                "Buffer Slab Inline Primitive",
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Growth", package: "swift-growth"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Inline",
                    package: "swift-memory-inline"
                ),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Finite Bounded", package: "swift-finite"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Sequence", package: "swift-sequence"),
            ]
        ),

        .target(
            name: "Buffer Slab",
            dependencies: [
                "Buffer Slab Primitive",
                "Buffer Slab Bounded",
                "Buffer Slab Inline",
                "Buffer Slab Small",
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Buffer Slab Bounded",
            dependencies: [
                "Buffer Slab Bounded Primitive",
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Buffer Slab Inline",
            dependencies: [
                "Buffer Slab Inline Primitive",
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Inline",
                    package: "swift-memory-inline"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Finite Bounded", package: "swift-finite"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Buffer Slab Small",
            dependencies: [
                "Buffer Slab Small Primitive",
                "Buffer Slab Primitive",
                "Buffer Slab Inline",
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
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
                .product(
                    name: "Memory Test Support",
                    package: "swift-memory"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Buffer Slab Tests",
            dependencies: [
                "Buffer Slab", "Buffer Slab Test Support",
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Small", package: "swift-memory-small"),
            ]
        ),
        .testTarget(
            name: "Buffer Slab Bounded Tests",
            dependencies: [
                "Buffer Slab Bounded", "Buffer Slab Test Support",
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Small", package: "swift-memory-small"),
            ]
        ),
        .testTarget(
            name: "Buffer Slab Inline Tests",
            dependencies: [
                "Buffer Slab Inline", "Buffer Slab Test Support",
                .product(name: "Finite Bounded", package: "swift-finite"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),

                .product(name: "Store Inline", package: "swift-storage"),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(name: "Index", package: "swift-index"),
            ]
        ),
        .testTarget(
            name: "Buffer Slab Small Tests",
            dependencies: [
                "Buffer Slab Small", "Buffer Slab Test Support",
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
            ]
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
