import Affine_Primitives_Standard_Library_Integration
public import Finite_Bounded_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Store_Inline_Primitives

extension Buffer.Slab.Inline where S: ~Copyable {

    @inlinable
    public init() {
        self.init(
            header: .init(),
            storage: Store.Inline<S.Element, wordCount>()
        )
    }

    @inlinable
    public var occupancy: Bit.Index.Count { box.occupancy }

    @inlinable
    public var count: Index<Element>.Count { box.occupancy.retag(Element.self) }

    @inlinable
    public var isEmpty: Bool { box.isEmpty }

    @inlinable
    public var isFull: Bool { box.isFull(capacity: Bit.Index.Count(UInt(wordCount))) }

    @inlinable
    public func isOccupied(at slot: Bit.Index.Bounded<wordCount>) -> Bool {
        box.isOccupied(at: Bit.Index(slot))
    }

    @inlinable
    public mutating func insert(
        _ element: consuming S.Element,
        at slot: Bit.Index.Bounded<wordCount>
    ) {
        box.insert(consume element, at: Bit.Index(slot))
    }

    @inlinable
    public mutating func remove(at slot: Bit.Index.Bounded<wordCount>) -> S.Element {
        box.remove(at: Bit.Index(slot))
    }

    @inlinable
    public mutating func update(
        at slot: Bit.Index.Bounded<wordCount>,
        with element: consuming S.Element
    ) -> S.Element {
        box.update(at: Bit.Index(slot), with: consume element)
    }

    @inlinable
    public func firstVacant() -> Bit.Index.Bounded<wordCount>? {
        guard let slot = box.firstVacant(max: Bit.Index.Count(UInt(wordCount))) else { return nil }

        guard let bounded = Bit.Index.Bounded<wordCount>(slot) else {
            preconditionFailure("box.firstVacant returned a slot outside wordCount")
        }
        return bounded
    }

    @inlinable
    public mutating func removeAll() {
        box.removeAll()
    }
}

extension Buffer.Slab.Inline where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func peek(at slot: Bit.Index.Bounded<wordCount>) -> S.Element {
        box.peek(at: Bit.Index(slot))
    }

    @inlinable
    package func peek(at slot: Bit.Index) -> S.Element {
        box.peek(at: slot)
    }
}

extension Buffer.Slab.Inline where S: ~Copyable {

    @inlinable
    package func _occupiedElements() -> [S.Element] where S.Element: Copyable {
        box.occupiedElements(max: wordCount)
    }
}

extension Buffer.Slab.Inline where S: ~Copyable {

    @inlinable
    package mutating func insert(_ element: consuming S.Element, at slot: Bit.Index) {
        box.insert(consume element, at: slot)
    }

    @inlinable
    package mutating func remove(at slot: Bit.Index) -> S.Element {
        box.remove(at: slot)
    }

    @inlinable
    package mutating func update(at slot: Bit.Index, with element: consuming S.Element) -> S.Element
    {
        box.update(at: slot, with: consume element)
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
