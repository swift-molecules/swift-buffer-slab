import Buffer_Slab_Inline
import Buffer_Slab_Test_Support
import Index
import Memory_Allocator
import Memory_Small
import Storage
import Testing

enum `Buffer.Slab.Inline Release Safety Tests` {}

extension `Buffer.Slab.Inline Release Safety Tests` {
    @Suite
    struct `Buffer.Slab.Inline - Release Safety` {

        @Test
        func `insert at a sparse slot keeps its occupancy bit in every build`() {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab.Inline<
                4
            >()
            let slot: Index::Index<Bit::Bit> = 2
            buffer.insert(42, at: slot)
            #expect(buffer.occupancy == 1)
            #expect(buffer.isOccupied(at: slot) == true)

        }

        @Test
        func `remove at a sparse slot returns the element in every build`() {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab.Inline<
                4
            >()
            let slot: Index::Index<Bit::Bit> = 1
            buffer.insert(10, at: slot)
            #expect(buffer.remove(at: slot) == 10)

        }

        @Test
        func `removeAll empties the buffer in every build`() {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab.Inline<
                4
            >()
            buffer.removeAll()
            #expect(buffer.isEmpty == true)

        }

        @Test
        func `empty-buffer construction and read-only queries`() {

            let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab.Inline<4>()
            #expect(buffer.isEmpty == true)
            #expect(buffer.occupancy == .zero)
            #expect(buffer.isOccupied(at: 0) == false)
        }
    }
}
