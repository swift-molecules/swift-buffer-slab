public import Index
import Affine
public import Bit_Vector_Bounded
import Growth
public import Memory_Allocator
public import Memory_Small
import Ordinal
public import Storage_Memory

extension Property.Borrow where Base: ~Copyable {

    @inlinable
    public func occupied<Element>(
        _ body: (Index::Index<Bit::Bit>) -> Void
    )
    where
        Tag == Sequence.ForEach,
        Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Slab
    {
        base.value.header.bitmap.ones.forEach(body)
    }
}
