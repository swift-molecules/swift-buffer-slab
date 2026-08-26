import Affine_Standard_Library_Integration
public import Bit_Vector_Bounded
import Growth
public import Memory_Allocator_Primitive
public import Memory_Heap
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous

extension Property.Borrow where Base: ~Copyable {

    @inlinable
    public func occupied<Element>(
        _ body: (Bit.Index) -> Void
    )
    where
        Tag == Sequence.ForEach,
        Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Slab
    {
        base.value.header.bitmap.ones.forEach(body)
    }
}
