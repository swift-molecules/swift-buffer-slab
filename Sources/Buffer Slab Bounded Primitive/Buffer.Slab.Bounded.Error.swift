import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration

extension Buffer.Slab.Bounded where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
