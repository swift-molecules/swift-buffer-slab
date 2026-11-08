import Affine
public import Bit_Vector_Bounded
import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Ordinal
public import Storage

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
