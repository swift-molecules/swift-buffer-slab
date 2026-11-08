import Affine
import Bit_Vector_Bounded
import Index
import Ordinal
import Storage

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
