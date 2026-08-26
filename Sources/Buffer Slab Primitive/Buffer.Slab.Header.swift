import Affine_Standard_Library_Integration
public import Bit_Vector_Bounded
import Growth
import Ordinal_Standard_Library_Integration

extension Buffer.Slab where S: ~Copyable {

    public struct Header {

        public var bitmap: Bit.Vector.Bounded

        @inlinable
        public init(capacity: Bit.Index.Count) {
            do throws(Bit.Vector.Bounded.Error) {
                self.bitmap = try Bit.Vector.Bounded(capacity: capacity, count: capacity)
            } catch {
                preconditionFailure(
                    "Bit.Vector.Bounded(capacity:count:) cannot overflow when count == capacity: \(error)"
                )
            }
        }
    }
}

extension Buffer.Slab.Header where S: ~Copyable {

    @inlinable
    public var occupancy: Bit.Index.Count {
        bitmap.popcount
    }

    @inlinable
    public var isEmpty: Bool {
        bitmap.popcount == .zero
    }

    @inlinable
    public var isFull: Bool {
        bitmap.popcount >= bitmap.capacity.maximum
    }

    @inlinable
    public func isOccupied(at slot: Bit.Index) -> Bool {
        bitmap[slot]
    }

    @inlinable
    public func firstVacant(max: Bit.Index.Count) -> Bit.Index? {
        bitmap.zeros.first(max: max)
    }
}
