import Affine_Standard_Library_Integration
public import Bit_Vector_Bounded
public import Cardinal
public import Memory_Allocator_Primitive
public import Memory_Allocator_Protocol
import Ordinal_Standard_Library_Integration
import Sequence
public import Storage_Memory
public import Tagged

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>
    ) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        let storage = S.create(minimumCapacity: minimumCapacity)
        self.init(
            header: Self.Header(capacity: storage.capacity.retag(Bit.self)),
            storage: storage
        )
    }
}

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public var occupancy: Tagged<Bit, Cardinal> { header.occupancy }

    @inlinable
    public var count: Tagged<Element, Cardinal> { occupancy.retag(Element.self) }

    @inlinable
    public var isEmpty: Bool { header.isEmpty }

    @inlinable
    public var isFull: Bool { header.isFull }

    @inlinable
    public func isOccupied(at slot: Bit.Index) -> Bool {
        header.isOccupied(at: slot)
    }

    @inlinable
    public var occupiedSlots: Bit.Vector.Ones.Bounded {
        header.bitmap.ones
    }

    @inlinable
    public mutating func insert(_ element: consuming S.Element, at slot: Bit.Index) {

        Self.insert(consume element, at: slot, header: &box.header, storage: &box.storage)
    }

    @inlinable
    public mutating func remove(at slot: Bit.Index) -> S.Element {
        Self.remove(at: slot, header: &box.header, storage: &box.storage)
    }

    @inlinable
    public mutating func update(at slot: Bit.Index, with element: consuming S.Element) -> S.Element
    {
        Self.update(at: slot, with: consume element, storage: &box.storage)
    }

    @inlinable
    public func firstVacant() -> Bit.Index? {
        Self.firstVacant(header: header)
    }

    @inlinable
    public mutating func removeAll() {
        Self.deinitializeAll(header: &box.header, storage: &box.storage)
    }
}

extension Buffer.Slab: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        box.header.bitmap.ones.forEach { bitIndex in
            body(Self.remove(at: bitIndex, header: &box.header, storage: &box.storage))
        }
    }
}

extension Buffer.Slab where S: ~Copyable {

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
