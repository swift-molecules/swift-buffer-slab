import Affine_Primitives_Standard_Library_Integration
import Bit_Vector_Static_Primitives
import Index_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Store_Initialization_Primitives
public import Store_Inline_Primitives

extension Buffer.Slab where S: ~Copyable {

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

    @usableFromInline
    internal final class Box {
        @usableFromInline
        internal var header: Buffer.Slab.Header.Static<wordCount>

        @usableFromInline
        internal var storage: Store.Inline<S.Element, wordCount>

        @usableFromInline
        internal init(
            header: Buffer.Slab.Header.Static<wordCount>,
            storage: consuming Store.Inline<S.Element, wordCount>
        ) {
            self.header = header
            self.storage = storage
        }

        deinit {
            var slot: Bit.Index = .zero
            let end = Bit.Index.Count(UInt(wordCount)).map(Ordinal.init)
            while slot < end {
                if header.bitmap[slot] {
                    _ = storage.move(at: slot.retag(S.Element.self))
                }
                slot += .one
            }
        }
    }
}

extension Buffer.Slab.Inline.Box where S: ~Copyable {

    @usableFromInline var occupancy: Bit.Index.Count { header.occupancy }
    @usableFromInline var isEmpty: Bool { header.isEmpty }
    @usableFromInline
    func isFull(capacity: Bit.Index.Count) -> Bool { header.occupancy >= capacity }
    @usableFromInline
    func isOccupied(at slot: Bit.Index) -> Bool { header.isOccupied(at: slot) }
    @usableFromInline
    func firstVacant(max: Bit.Index.Count) -> Bit.Index? { header.firstVacant(max: max) }

    @usableFromInline
    static func _preconditionReleaseSound(function: StaticString = #function) {
        precondition(
            _isDebugAssertConfiguration(),
            "Buffer.Slab.Inline/.Small mutation (\(function)) is release-mode-unsound "
                + "(swift-issue-inlinearray-class-field-write-elision): the box-owned occupancy "
                + "bitmap write is elided under -O, silently corrupting sparse occupancy. "
                + "Blocked pending the occupancy-placement decision — see the type doc-comment "
                + "on Buffer.Slab.Inline and .handoffs/HANDOFF-sparse-occupancy-placement.md."
        )
    }

    @usableFromInline
    func insert(_ element: consuming S.Element, at slot: Bit.Index) {
        Self._preconditionReleaseSound()
        storage.initialize(at: slot.retag(S.Element.self), to: consume element)
        storage.initialization = .empty
        header.bitmap[slot] = true
    }

    @usableFromInline
    func remove(at slot: Bit.Index) -> S.Element {
        Self._preconditionReleaseSound()
        let element = storage.move(at: slot.retag(S.Element.self))
        storage.initialization = .empty
        header.bitmap[slot] = false
        return element
    }

    @usableFromInline
    func update(at slot: Bit.Index, with element: consuming S.Element) -> S.Element {
        Self._preconditionReleaseSound()
        let index = slot.retag(S.Element.self)
        let old = storage.move(at: index)
        storage.initialize(at: index, to: consume element)
        storage.initialization = .empty
        return old
    }

    @usableFromInline
    func removeAll() {
        Self._preconditionReleaseSound()
        var slot: Bit.Index = .zero
        let end = Bit.Index.Count(UInt(wordCount)).map(Ordinal.init)
        while slot < end {
            if header.bitmap[slot] {
                _ = storage.move(at: slot.retag(S.Element.self))
                storage.initialization = .empty
                header.bitmap[slot] = false
            }
            slot += .one
        }
    }

    @usableFromInline
    func drain(_ body: (consuming S.Element) -> Void) {
        Self._preconditionReleaseSound()
        var slot: Bit.Index = .zero
        let end = Bit.Index.Count(UInt(wordCount)).map(Ordinal.init)
        while slot < end {
            if header.bitmap[slot] {
                let element = storage.move(at: slot.retag(S.Element.self))
                storage.initialization = .empty
                header.bitmap[slot] = false
                body(consume element)
            }
            slot += .one
        }
    }
}

extension Buffer.Slab.Inline.Box where S: ~Copyable, S.Element: Copyable {
    @usableFromInline
    func peek(at slot: Bit.Index) -> S.Element { storage[slot.retag(S.Element.self)] }

    @usableFromInline
    func occupiedElements(max wordCount: Int) -> [S.Element] {
        var result: [S.Element] = []
        var slot: Bit.Index = .zero
        let end = Bit.Index.Count(UInt(wordCount)).map(Ordinal.init)
        while slot < end {
            if header.bitmap[slot] {
                result.append(storage[slot.retag(S.Element.self)])
            }
            slot += .one
        }
        return result
    }
}

extension Buffer.Slab.Inline: @unchecked Sendable where S: ~Copyable, S.Element: Sendable {}
