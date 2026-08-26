import Buffer_Slab_Test_Support
import Buffer_Slab_Small
import Memory_Allocator_Primitive
import Memory_Heap
import Storage_Contiguous
import Testing

@Suite
struct `Buffer.Slab.Small - Bounds Safety` {

    @Test
    func
        `insert at slot equal to inlineCapacity with vacancies forces a spill instead of an out-of-bounds write`()
        async
    {
        if _isDebugAssertConfiguration() {
            await #expect(processExitsWith: .success) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab
                    .Small<4>()
                buffer.insert(10, at: 0)
                buffer.insert(99, at: 4)
                precondition(buffer.isSpilled, "slot >= inlineCapacity must force a heap spill")
                precondition(buffer.occupancy == 2, "both elements must survive the spill")
                precondition(
                    buffer.peek(at: 0) == 10,
                    "the pre-spill element must survive the move"
                )
                precondition(
                    buffer.peek(at: 4) == 99,
                    "the out-of-range insert must land at its own slot on heap"
                )
            }
        } else {

            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab
                    .Small<4>()
                buffer.insert(10, at: 0)
            }
        }
    }

    @Test
    func `insert at slot equal to 2 times inlineCapacity sizes the heap spill to cover it`() async {
        await #expect(processExitsWith: .success) {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab.Small<
                4
            >()

            buffer.insert(7, at: 8)
            precondition(buffer.isSpilled, "must spill")
            precondition(buffer.isOccupied(at: 8), "the far slot must be reachable post-spill")
            precondition(buffer.peek(at: 8) == 7, "the far slot's value must be intact")
        }
    }

    @Test
    func `isOccupied at an out-of-inline-range slot reads vacant instead of trapping`() async {
        await #expect(processExitsWith: .success) {
            let buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab.Small<
                4
            >()

            precondition(
                buffer.isOccupied(at: 4) == false,
                "slot 4 was never occupiable inline — must read vacant, not trap"
            )
            precondition(buffer.isOccupied(at: 100) == false, "same for a slot far past capacity")
        }
    }

    @Test
    func `remove and update at an out-of-inline-range slot trap instead of reading out of bounds`()
        async
    {
        await #expect(processExitsWith: .failure) {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab.Small<
                4
            >()
            _ = buffer.remove(at: 4)
        }
        await #expect(processExitsWith: .failure) {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab.Small<
                4
            >()
            _ = buffer.update(at: 4, with: 1)
        }
    }
}
