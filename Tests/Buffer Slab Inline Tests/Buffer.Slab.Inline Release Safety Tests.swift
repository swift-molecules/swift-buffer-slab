import Buffer_Slab_Inline
import Buffer_Slab_Test_Support
import Memory_Allocator_Primitive
import Memory_Small
import Storage_Memory
import Testing

@Suite
struct `Buffer.Slab.Inline - Release Safety` {

    @Test
    func `insert on the documented triggering shape traps under release and succeeds under debug`()
        async
    {
        if _isDebugAssertConfiguration() {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab.Inline<
                4
            >()
            let slot: Bit.Index = 2
            buffer.insert(42, at: slot)
            #expect(buffer.occupancy == 1)
            #expect(buffer.isOccupied(at: slot) == true)
        } else {
            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab
                    .Inline<4>()
                let slot: Bit.Index = 2
                buffer.insert(42, at: slot)
            }
        }
    }

    @Test
    func `remove traps under release and succeeds under debug`() async {
        if _isDebugAssertConfiguration() {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab.Inline<
                4
            >()
            let slot: Bit.Index = 1
            buffer.insert(10, at: slot)
            #expect(buffer.remove(at: slot) == 10)
        } else {
            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab
                    .Inline<4>()
                let slot: Bit.Index = 1
                _ = buffer.remove(at: slot)
            }
        }
    }

    @Test
    func `empty-buffer construction and read-only queries remain usable under release`() {

        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab.Inline<4>()
        #expect(buffer.isEmpty == true)
        #expect(buffer.occupancy == .zero)
        #expect(buffer.isOccupied(at: 0) == false)
    }
}
