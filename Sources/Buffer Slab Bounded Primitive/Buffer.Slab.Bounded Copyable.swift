import Affine_Primitives_Standard_Library_Integration
public import Bit_Vector_Bounded_Primitives
import Index_Primitives
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives
public import Store_Protocol_Primitives

extension Buffer.Slab.Bounded where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func peek(at slot: Bit.Index) -> S.Element {
        let storageIndex = slot.retag(S.Element.self)
        return storage[storageIndex]
    }
}

extension Buffer.Slab.Bounded where S: ~Copyable {

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

extension Buffer.Slab.Bounded where S: ~Copyable {

    @inlinable
    public init<E, Resource: Memory.Growable & ~Copyable>(
        _ elements: [E],
        capacity: UInt
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        guard elements.count <= Int(capacity) else { throw .capacityExceeded }
        var buffer = Self(minimumCapacity: Index<E>.Count(Cardinal(capacity)))
        for (i, element) in elements.enumerated() {
            buffer.insert(element, at: Bit.Index(Ordinal(UInt(i))))
        }
        self = buffer
    }
}
