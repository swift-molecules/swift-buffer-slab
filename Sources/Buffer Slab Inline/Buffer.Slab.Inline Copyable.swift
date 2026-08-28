import Affine_Standard_Library_Integration
public import Iterator
import Ordinal_Standard_Library_Integration

public typealias BufferSlabMaterializingIterator<
    Source: Iterating & ~Copyable & ~Escapable
> = Iterator.Materializing<Source>
where Source.Element: Copyable & Escapable

extension Buffer.Slab.Inline where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public init(_ elements: [S.Element]) throws(Self.Error) {
        guard elements.count <= wordCount else { throw .capacityExceeded }
        var buffer = Self()
        for (i, element) in elements.enumerated() {
            let slot = Bit.Index(Ordinal(UInt(i)))
            buffer.insert(element, at: slot)
        }
        self = buffer
    }
}

extension Buffer.Slab.Inline: Iterable where S: ~Copyable, S.Element: Copyable {

    public struct Iterator: Iterating, IteratorProtocol,
        @unchecked Sendable
    {

        @usableFromInline
        let elements: [S.Element]
        @usableFromInline
        var position: Int

        @inlinable
        package init(elements: [S.Element]) {
            self.elements = elements
            self.position = 0
        }
    }

    public borrowing func makeIterator() -> Iterator {

        Iterator(elements: _occupiedElements())
    }

    @_implements(Iterable,Iterator)
    public typealias IterableIterator = BufferSlabMaterializingIterator<Iterator>

    @_implements(Iterable,makeIterator())
    public borrowing func iterableMakeIterator()
        -> BufferSlabMaterializingIterator<Iterator>
    {
        BufferSlabMaterializingIterator(Iterator(elements: _occupiedElements()))
    }
}

extension Buffer.Slab.Inline.Iterator where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public mutating func next() -> S.Element? {
        guard position < elements.count else { return nil }
        defer { position += 1 }
        return elements[position]
    }
}
