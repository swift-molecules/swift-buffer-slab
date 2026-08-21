import Affine_Primitives_Standard_Library_Integration
public import Bit_Vector_Bounded_Primitives
import Growth_Primitives
import Ordinal_Primitives_Standard_Library_Integration
import Storage_Protocol_Primitives
public import Store_Protocol_Primitives

extension Buffer.Slab where S: ~Copyable {

    @inlinable
    public static func insert(
        _ element: consuming S.Element,
        at slot: Bit.Index,
        header: inout Header,
        storage: inout S
    ) {
        storage.initialize(at: slot.retag(S.Element.self), to: consume element)
        header.bitmap[slot] = true
    }

    @inlinable
    public static func remove(
        at slot: Bit.Index,
        header: inout Header,
        storage: inout S
    ) -> S.Element {
        let element = storage.move(at: slot.retag(S.Element.self))
        header.bitmap[slot] = false
        return element
    }

    @inlinable
    public static func update(
        at slot: Bit.Index,
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
    ) -> Bit.Index? {
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
