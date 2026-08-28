import Affine_Standard_Library_Integration
public import Bit_Vector_Bounded
import Growth
import Ordinal_Standard_Library_Integration
public import Storage

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public var capacity: Tagged<Bit, Cardinal> {
        header.bitmap.capacity.maximum
    }
}

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public subscript(slot: Bit.Index) -> S.Element {
        _read {
            yield storage[slot.retag(S.Element.self)]
        }
    }
}

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public var forEach: Property<Sequence.ForEach, Self>.Borrow {
        _read {
            yield Property<Sequence.ForEach, Self>.Borrow(self)
        }
    }
}
