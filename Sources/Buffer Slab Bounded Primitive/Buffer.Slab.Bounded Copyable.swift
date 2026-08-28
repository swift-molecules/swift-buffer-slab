import Affine_Standard_Library_Integration
public import Bit_Vector_Bounded
public import Cardinal
import Index
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol
import Ordinal_Standard_Library_Integration
public import Storage_Memory
public import Storage
public import Tagged

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
        var buffer = Self(minimumCapacity: Tagged<E, Cardinal>(_unchecked: Cardinal(capacity)))
        for (i, element) in elements.enumerated() {
            buffer.insert(element, at: Bit.Index(Ordinal(UInt(i))))
        }
        self = buffer
    }
}
