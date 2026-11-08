import Affine
import Bit_Vector_Bounded
import Index
import Ordinal
import Storage

extension Buffer.Slab.Bounded where S: ~Copyable {
    @usableFromInline
    internal final class Box {
        @usableFromInline
        internal var header: Buffer.Slab.Header

        @usableFromInline
        internal var storage: S

        @usableFromInline
        internal init(header: Buffer.Slab.Header, storage: consuming S) {
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
