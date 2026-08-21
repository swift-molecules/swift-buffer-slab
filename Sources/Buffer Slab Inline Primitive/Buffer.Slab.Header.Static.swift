import Affine_Primitives_Standard_Library_Integration
import Bit_Vector_Static_Primitives
import Ordinal_Primitives_Standard_Library_Integration

extension Buffer.Slab.Header where S: ~Copyable {

    public struct Static<let wordCount: Int>: Copyable, Sendable {

        public var bitmap: Bit.Vector.Static<wordCount>

        @inlinable
        public init() {
            self.bitmap = .init()
        }
    }
}
