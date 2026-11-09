import Affine
import Bit_Vector_Static
import Index
import Ordinal
public import Storage

extension Buffer.Slab where S: ~Copyable {

    /// A slab of `wordCount` slots stored inline in a class box.
    ///
    /// Occupancy has one owner: the bitmap in the box's header. The store's
    /// initialization ledger is kept empty between operations and names a slot
    /// only while an element is moved out of it, so teardown, `removeAll()`,
    /// `drain` and every mutation consult the bitmap alone.
    public struct Inline<let wordCount: Int>: ~Copyable {

        @usableFromInline
        internal var box: Box

        @inlinable
        package init(
            header: Header.Static<wordCount>,
            storage: consuming Store.Inline<S.Element, wordCount>
        ) {
            self.box = Box(header: header, storage: storage)
        }
    }
}

extension Buffer.Slab.Inline where S: ~Copyable {
}

extension Buffer.Slab.Inline.Box where S: ~Copyable {

    @usableFromInline var occupancy: Tagged<Bit, Cardinal> { header.occupancy }
    @usableFromInline var isEmpty: Bool { header.isEmpty }
    @usableFromInline
    func isFull(capacity: Tagged<Bit, Cardinal>) -> Bool { header.occupancy >= capacity }
    @usableFromInline
    func isOccupied(at slot: Index::Index<Bit::Bit>) -> Bool { header.isOccupied(at: slot) }
    @usableFromInline
    func firstVacant(max: Tagged<Bit, Cardinal>) -> Index::Index<Bit::Bit>? { header.firstVacant(max: max) }

    /// Moves the element out of an occupied slot.
    ///
    /// The bitmap owns occupancy, so the store's ledger is kept empty between
    /// operations; it names only this slot for the duration of the move.
    @usableFromInline
    func vacate(_ slot: Index::Index<Bit::Bit>) -> S.Element {
        precondition(header.bitmap[slot], "move from a vacant slot")
        let index = slot.retag(S.Element.self)
        storage.initialization = Store.Initialization<S.Element>.empty.inserting(index)
        return storage.move(at: index)
    }

    @usableFromInline
    func insert(_ element: consuming S.Element, at slot: Index::Index<Bit::Bit>) {
        precondition(!header.bitmap[slot], "insert at an occupied slot")
        storage.initialize(at: slot.retag(S.Element.self), to: consume element)
        storage.initialization = .empty
        header.bitmap[slot] = true
    }

    @usableFromInline
    func remove(at slot: Index::Index<Bit::Bit>) -> S.Element {
        let element = vacate(slot)
        header.bitmap[slot] = false
        return element
    }

    @usableFromInline
    func update(at slot: Index::Index<Bit::Bit>, with element: consuming S.Element) -> S.Element {
        let old = vacate(slot)
        storage.initialize(at: slot.retag(S.Element.self), to: consume element)
        storage.initialization = .empty
        return old
    }

    @usableFromInline
    func removeAll() {
        var slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(0))
        let end = Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(wordCount))).map(Ordinal.init)
        while slot < end {
            if header.bitmap[slot] {
                _ = vacate(slot)
                header.bitmap[slot] = false
            }
            slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(slot.underlying.rawValue + 1))
        }
    }

    @usableFromInline
    func drain(_ body: (consuming S.Element) -> Void) {
        var slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(0))
        let end = Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(wordCount))).map(Ordinal.init)
        while slot < end {
            if header.bitmap[slot] {
                let element = vacate(slot)
                header.bitmap[slot] = false
                body(consume element)
            }
            slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(slot.underlying.rawValue + 1))
        }
    }
}

extension Buffer.Slab.Inline.Box where S: ~Copyable, S.Element: Copyable {
    @usableFromInline
    func peek(at slot: Index::Index<Bit::Bit>) -> S.Element {
        precondition(header.bitmap[slot], "peek at a vacant slot")
        return storage[slot.retag(S.Element.self)]
    }

    @usableFromInline
    func occupiedElements(max wordCount: Int) -> [S.Element] {
        var result: [S.Element] = []
        var slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(0))
        let end = Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(wordCount))).map(Ordinal.init)
        while slot < end {
            if header.bitmap[slot] {
                result.append(storage[slot.retag(S.Element.self)])
            }
            slot = Index::Index<Bit::Bit>(_unchecked: Ordinal(slot.underlying.rawValue + 1))
        }
        return result
    }
}

extension Buffer.Slab.Inline: @unchecked Sendable where S: ~Copyable, S.Element: Sendable {}
