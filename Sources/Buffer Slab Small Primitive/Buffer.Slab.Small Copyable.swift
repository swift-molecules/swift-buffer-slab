import Affine_Standard_Library_Integration
public import Finite_Bounded
import Ordinal_Standard_Library_Integration

extension Buffer.Slab.Small where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func peek(at slot: Bit.Index) -> S.Element {
        switch _storage {

        case .heap(let buf):
            return buf[slot]

        case .inline(let buf):
            guard let bounded = Bit.Index.Bounded<inlineCapacity>(slot) else {
                preconditionFailure("slot exceeds inlineCapacity — never occupiable in inline mode")
            }
            return buf.peek(at: bounded)
        }
    }
}
