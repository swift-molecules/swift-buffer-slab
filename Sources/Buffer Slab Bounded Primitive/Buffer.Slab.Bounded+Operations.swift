import Affine_Standard_Library_Integration
public import Bit_Vector_Bounded
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous

extension Buffer.Slab.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Index<E>.Count
    ) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        let storage = S.create(minimumCapacity: minimumCapacity)
        self.init(
            header: Buffer.Slab.Header(capacity: storage.capacity.retag(Bit.self)),
            storage: storage
        )
    }

    @inlinable
    public var occupancy: Bit.Index.Count { header.occupancy }

    @inlinable
    public var count: Index<Element>.Count { occupancy.retag(Element.self) }

    @inlinable
    public var isEmpty: Bool { header.isEmpty }

    @inlinable
    public var isFull: Bool { header.isFull }

    @inlinable
    public func isOccupied(at slot: Bit.Index) -> Bool {
        header.isOccupied(at: slot)
    }

    @inlinable
    public mutating func insert(_ element: consuming S.Element, at slot: Bit.Index) {
        Buffer.Slab.insert(consume element, at: slot, header: &box.header, storage: &box.storage)
    }

    @inlinable
    public mutating func remove(at slot: Bit.Index) -> S.Element {
        Buffer.Slab.remove(at: slot, header: &box.header, storage: &box.storage)
    }

    @inlinable
    public mutating func update(at slot: Bit.Index, with element: consuming S.Element) -> S.Element
    {
        Buffer.Slab.update(at: slot, with: consume element, storage: &box.storage)
    }

    @inlinable
    public func firstVacant() -> Bit.Index? {
        Buffer.Slab.firstVacant(header: header)
    }

    @inlinable
    public mutating func removeAll() {
        Buffer.Slab.deinitializeAll(header: &box.header, storage: &box.storage)
    }
}

extension Buffer.Slab.Bounded: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        box.header.bitmap.ones.forEach { bitIndex in
            body(Buffer.Slab.remove(at: bitIndex, header: &box.header, storage: &box.storage))
        }
    }
}

extension Buffer.Slab.Bounded where S: ~Copyable {

    @inlinable
    public var drain: Property<Sequence.Drain, Self>.Inout {
        mutating _read {
            yield Property<Sequence.Drain, Self>.Inout(&self)
        }
        mutating _modify {
            var accessor = Property<Sequence.Drain, Self>.Inout(&self)
            yield &accessor
        }
    }
}

extension Buffer.Slab.Bounded where S: ~Copyable {

    @inlinable
    public var forEach: Property<Sequence.ForEach, Self>.Borrow {
        _read {
            yield Property<Sequence.ForEach, Self>.Borrow(self)
        }
    }
}
