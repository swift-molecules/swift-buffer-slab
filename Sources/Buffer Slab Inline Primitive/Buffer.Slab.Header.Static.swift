import Affine
import Bit_Vector_Static
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
