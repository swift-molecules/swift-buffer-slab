import Affine
public import Index
import Ordinal

extension Buffer.Slab.Small where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func peek(at slot: Index::Index<Bit::Bit>) -> S.Element {
        switch _storage {

        case .heap(let buf):
            return buf[slot]

        case .inline(let buf):
            return buf.peek(at: slot)
        }
    }
}
