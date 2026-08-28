import Affine_Standard_Library_Integration
public import Cardinal
import Ordinal_Standard_Library_Integration
public import Storage
public import Tagged

extension Buffer.Slab.Inline where S: ~Copyable {

    @usableFromInline
    static var _slotLimit: Bit.Index {
        Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(wordCount))).map(Ordinal.init)
    }

    @inlinable
    public init() {
        self.init(
            header: .init(),
            storage: Store.Inline<S.Element, wordCount>()
        )
    }

    @inlinable
    public var occupancy: Tagged<Bit, Cardinal> { box.occupancy }

    @inlinable
    public var count: Tagged<Element, Cardinal> { box.occupancy.retag(Element.self) }

    @inlinable
    public var isEmpty: Bool { box.isEmpty }

    @inlinable
    public var isFull: Bool {
        box.isFull(capacity: Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(wordCount))))
    }

    @inlinable
    public func isOccupied(at slot: Bit.Index) -> Bool {
        guard slot < Self._slotLimit else { return false }
        return box.isOccupied(at: slot)
    }

    @inlinable
    public mutating func insert(
        _ element: consuming S.Element,
        at slot: Bit.Index
    ) {
        precondition(slot < Self._slotLimit, "slot exceeds wordCount")
        box.insert(consume element, at: slot)
    }

    @inlinable
    public mutating func remove(at slot: Bit.Index) -> S.Element {
        precondition(slot < Self._slotLimit, "slot exceeds wordCount")
        return box.remove(at: slot)
    }

    @inlinable
    public mutating func update(
        at slot: Bit.Index,
        with element: consuming S.Element
    ) -> S.Element {
        precondition(slot < Self._slotLimit, "slot exceeds wordCount")
        return box.update(at: slot, with: consume element)
    }

    @inlinable
    public func firstVacant() -> Bit.Index? {
        guard
            let slot = box.firstVacant(
                max: Tagged<Bit, Cardinal>(_unchecked: Cardinal(UInt(wordCount)))
            )
        else { return nil }

        return slot
    }

    @inlinable
    public mutating func removeAll() {
        box.removeAll()
    }
}

extension Buffer.Slab.Inline where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func peek(at slot: Bit.Index) -> S.Element {
        precondition(slot < Self._slotLimit, "slot exceeds wordCount")
        return box.peek(at: slot)
    }
}

extension Buffer.Slab.Inline where S: ~Copyable {

    @inlinable
    package func _occupiedElements() -> [S.Element] where S.Element: Copyable {
        box.occupiedElements(max: wordCount)
    }
}

extension Buffer.Slab.Inline: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        box.drain(body)
    }
}

extension Buffer.Slab.Inline where S: ~Copyable {

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
