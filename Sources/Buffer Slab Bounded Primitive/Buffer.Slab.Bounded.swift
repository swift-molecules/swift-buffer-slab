import Affine
import Bit_Vector_Bounded
import Index
import Ordinal
import Storage

extension Buffer.Slab where S: ~Copyable {

    public struct Bounded: ~Copyable {

        @usableFromInline
        internal var box: Box

        @inlinable
        package init(
            header: Header,
            storage: consuming S
        ) {
            self.box = Box(header: header, storage: storage)
        }
    }
}

extension Buffer.Slab.Bounded where S: ~Copyable {
}

extension Buffer.Slab.Bounded where S: ~Copyable {

    @usableFromInline
    internal var header: Buffer.Slab.Header {
        @inlinable _read { yield box.header }
        @inlinable _modify { yield &box.header }
    }

    @usableFromInline
    internal var storage: S {
        @inlinable _read { yield box.storage }
        @inlinable _modify { yield &box.storage }
    }
}

extension Buffer.Slab.Bounded: @unsafe @unchecked Sendable where S: Sendable {}
