import Affine_Primitives_Standard_Library_Integration
public import Bit_Vector_Bounded_Primitives
import Growth_Primitives
import Ordinal_Primitives_Standard_Library_Integration
import Storage_Protocol_Primitives
public import Store_Protocol_Primitives

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public var capacity: Bit.Index.Count {
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
