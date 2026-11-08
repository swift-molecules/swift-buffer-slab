import Affine
import Bit_Vector_Static
import Index
import Ordinal
import Storage

extension Buffer.Slab.Inline where S: ~Copyable {
    @usableFromInline
    internal final class Box {
        @usableFromInline
        internal var header: Buffer.Slab.Header.Static<wordCount>

        @usableFromInline
        internal var storage: Store.Inline<S.Element, wordCount>

        @usableFromInline
        internal init(
            header: Buffer.Slab.Header.Static<wordCount>,
            storage: consuming Store.Inline<S.Element, wordCount>
        ) {
            self.header = header
            self.storage = storage
        }

        deinit {
            var slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(0))
            let end = Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(wordCount))).map(Ordinal.init)
            while slot < end {
                if header.bitmap[slot] {
                    _ = storage.move(at: slot.retag(S.Element.self))
                }
                slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(slot.underlying.rawValue + 1))
            }
        }
    }
}
