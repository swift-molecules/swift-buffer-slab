import Affine_Standard_Library_Integration
public import Finite_Bounded
public import Iterator_Chunk
public import Iterator_Primitive
import Ordinal_Standard_Library_Integration

extension Buffer.Slab.Inline where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public init(_ elements: [S.Element]) throws(Self.Error) {
        guard elements.count <= wordCount else { throw .capacityExceeded }
        var buffer = Self()
        for (i, element) in elements.enumerated() {
            guard let slot = Bit.Index.Bounded<wordCount>(Bit.Index(Ordinal(UInt(i)))) else {
                preconditionFailure("element index exceeds wordCount")
            }
            buffer.insert(element, at: slot)
        }
        self = buffer
    }
}

extension Buffer.Slab.Inline: Iterable where S: ~Copyable, S.Element: Copyable {

    public struct Iterator: Iterator_Primitive.Iterator.`Protocol`, IteratorProtocol,
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
    public typealias IterableIterator = Iterator_Primitive.Iterator.Materializing<Iterator>

    @_implements(Iterable,makeIterator())
    public borrowing func iterableMakeIterator()
        -> Iterator_Primitive.Iterator.Materializing<Iterator>
    {
        Iterator_Primitive.Iterator.Materializing(Iterator(elements: _occupiedElements()))
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
