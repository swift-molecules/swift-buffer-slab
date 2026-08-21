import Affine_Primitives_Standard_Library_Integration
import Bit_Vector_Bounded_Primitives
import Index_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Protocol_Primitives
public import Store_Protocol_Primitives

extension Buffer where S: Store.`Protocol`, S: ~Copyable {

    public struct Slab: ~Copyable {

        @usableFromInline
        internal var box: Box

        @inlinable
        package init(header: Header, storage: consuming S) {
            self.box = Box(header: header, storage: storage)
        }
    }
}

extension Buffer.Slab where S: ~Copyable {

    @usableFromInline
    internal final class Box {
        @usableFromInline
        internal var header: Header

        @usableFromInline
        internal var storage: S

        @usableFromInline
        internal init(header: Header, storage: consuming S) {
            self.header = header
            self.storage = storage
        }

        deinit {
            header.bitmap.ones.forEach { bitIndex in
                _ = storage.move(at: bitIndex.retag(S.Element.self))
            }
        }
    }
}

extension Buffer.Slab where S: ~Copyable {

    @usableFromInline
    internal var header: Header {
        @inlinable _read { yield box.header }
        @inlinable _modify { yield &box.header }
    }

    @usableFromInline
    internal var storage: S {
        @inlinable _read { yield box.storage }
        @inlinable _modify { yield &box.storage }
    }
}

extension Buffer.Slab: @unsafe @unchecked Sendable where S: Sendable {}
