import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration

extension Buffer.Slab.Small where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func peek(at slot: Bit.Index) -> S.Element {
        switch _storage {

        case .heap(let buf):
            return buf[slot]

        case .inline(let buf):
            return buf.peek(at: slot)
        }
    }
}
