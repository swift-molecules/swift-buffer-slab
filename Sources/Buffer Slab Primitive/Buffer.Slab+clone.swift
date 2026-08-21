import Affine_Primitives_Standard_Library_Integration
public import Bit_Vector_Bounded_Primitives
import Index_Primitives
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public func clone<E, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable {
        let capacity = storage.capacity
        var fresh = S.create(minimumCapacity: capacity)
        header.bitmap.ones.forEach { bitIndex in
            let index = bitIndex.retag(E.self)
            let element = storage[index]
            fresh.initialize(at: index, to: element)
        }
        return Self(header: header, storage: fresh)
    }
}
