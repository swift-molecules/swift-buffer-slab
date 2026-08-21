import Affine_Primitives_Standard_Library_Integration
public import Bit_Vector_Bounded_Primitives
import Growth_Primitives
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives

extension Property.Borrow where Base: ~Copyable {

    @inlinable
    public func occupied<Element>(
        _ body: (Bit.Index) -> Void
    )
    where
        Tag == Sequence.ForEach,
        Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Slab.Bounded
    {
        base.value.header.bitmap.ones.forEach(body)
    }
}
