import Affine_Standard_Library_Integration
import Index
import Ordinal_Standard_Library_Integration

extension Buffer.Slab.Inline where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
