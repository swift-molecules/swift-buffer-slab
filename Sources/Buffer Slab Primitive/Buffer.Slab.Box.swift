import Affine
import Bit_Vector_Bounded
import Index
import Ordinal
import Storage


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
