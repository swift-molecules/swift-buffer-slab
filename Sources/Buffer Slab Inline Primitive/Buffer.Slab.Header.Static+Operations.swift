import Affine_Standard_Library_Integration
public import Growth
import Ordinal_Standard_Library_Integration

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
    public func isOccupied(at slot: Bit.Index) -> Bool {
        bitmap[slot]
    }

    @inlinable
    public func firstVacant(max: Tagged<Bit, Cardinal>) -> Bit.Index? {
        bitmap.zeros.first(max: max)
    }
}
