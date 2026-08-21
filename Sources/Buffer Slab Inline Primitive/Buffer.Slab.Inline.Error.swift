import Affine_Primitives_Standard_Library_Integration
import Index_Primitives
import Ordinal_Primitives_Standard_Library_Integration

extension Buffer.Slab.Inline where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
