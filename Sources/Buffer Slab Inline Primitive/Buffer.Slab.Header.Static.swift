import Affine
import Bit_Vector_Static
public import Growth
public import Index
import Ordinal

extension Buffer.Slab.Header where S: ~Copyable {

    public struct Static<let wordCount: Int>: Copyable, Sendable {

        public var bitmap: Bit.Vector.Static<wordCount>

        @inlinable
        public init() {
            self.bitmap = .init()
        }
    }
}

extension Buffer.Slab.Header.Static where S: ~Copyable {

    @inlinable
    public var occupancy: Tagged<Bit, Cardinal> {
        bitmap.popcount
    }

    @inlinable
    public var isEmpty: Bool {
        bitmap.isEmpty
    }

    @inlinable
    public var isFull: Bool {
        bitmap.isFull
    }

    @inlinable
    public func isOccupied(at slot: Index::Index<Bit::Bit>) -> Bool {
        bitmap[slot]
    }

    @inlinable
    public func firstVacant(max: Tagged<Bit, Cardinal>) -> Index::Index<Bit::Bit>? {
        bitmap.zeros.first(max: max)
    }
}
