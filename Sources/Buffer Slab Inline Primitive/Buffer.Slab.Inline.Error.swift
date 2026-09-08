import Affine
import Index
import Ordinal

extension Buffer.Slab.Inline where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
