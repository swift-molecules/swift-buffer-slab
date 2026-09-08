public import Index
import Affine
public import Growth
import Ordinal

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
