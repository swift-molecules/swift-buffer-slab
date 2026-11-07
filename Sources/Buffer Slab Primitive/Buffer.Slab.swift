import Affine
import Bit_Vector_Bounded
import Index
import Ordinal
import Storage
import Growth
public import Memory_Allocator
public import Memory_Allocator_Protocol

extension Buffer where S: Store.`Protocol`, S: ~Copyable {

    public struct Slab: ~Copyable {

        @usableFromInline
        internal var box: Box

        @inlinable
        package init(header: Header, storage: consuming S) {
            self.box = Box(header: header, storage: storage)
        }
    }
}

extension Buffer.Slab where S: ~Copyable {

    @usableFromInline
    internal final class Box {
        @usableFromInline
        internal var header: Header

        @usableFromInline
        internal var storage: S

        @usableFromInline
        internal init(header: Header, storage: consuming S) {
            self.header = header
            self.storage = storage
        }

        deinit {
            header.bitmap.ones.forEach { bitIndex in
                _ = storage.move(at: bitIndex.retag(S.Element.self))
            }
        }
    }
}

extension Buffer.Slab where S: ~Copyable {

    @usableFromInline
    internal var header: Header {
        @inlinable _read { yield box.header }
        @inlinable _modify { yield &box.header }
    }

    @usableFromInline
    internal var storage: S {
        @inlinable _read { yield box.storage }
        @inlinable _modify { yield &box.storage }
    }
}

extension Buffer.Slab: @unsafe @unchecked Sendable where S: Sendable {}

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public static func insert(
        _ element: consuming S.Element,
        at slot: Index::Index<Bit::Bit>,
        header: inout Header,
        storage: inout S
    ) {
        storage.initialize(at: slot.retag(S.Element.self), to: consume element)
        header.bitmap[slot] = true
    }

    @inlinable
    public static func remove(
        at slot: Index::Index<Bit::Bit>,
        header: inout Header,
        storage: inout S
    ) -> S.Element {
        let element = storage.move(at: slot.retag(S.Element.self))
        header.bitmap[slot] = false
        return element
    }

    @inlinable
    public static func update(
        at slot: Index::Index<Bit::Bit>,
        with element: consuming S.Element,
        storage: inout S
    ) -> S.Element {
        let storageIndex = slot.retag(S.Element.self)
        let old = storage.move(at: storageIndex)
        storage.initialize(at: storageIndex, to: consume element)
        return old
    }

    @inlinable
    public static func forEachOccupied(
        header: borrowing Header,
        storage: borrowing S,
        _ body: (Index<S.Element>) -> Void
    ) {
        header.bitmap.ones.forEach { bitIndex in
            body(bitIndex.retag(S.Element.self))
        }
    }

    @inlinable
    public static func firstVacant(
        header: borrowing Header
    ) -> Index::Index<Bit::Bit>? {
        header.firstVacant(max: header.bitmap.capacity.maximum)
    }

    @inlinable
    public static func deinitializeAll(
        header: inout Header,
        storage: inout S
    ) {
        header.bitmap.ones.forEach { bitIndex in

            _ = storage.move(at: bitIndex.retag(S.Element.self))
            header.bitmap[bitIndex] = false
        }
    }
}

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public var capacity: Tagged<Bit, Cardinal> {
        header.bitmap.capacity.maximum
    }
}

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public subscript(slot: Index::Index<Bit::Bit>) -> S.Element {
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
