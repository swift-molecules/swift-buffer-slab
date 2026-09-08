import Affine
import Ordinal

extension Buffer.Slab.Bounded where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
