import Buffer_Slab
import Buffer_Slab_Test_Support
import Index
import Memory_Allocator
import Memory_Small
import Storage
import Testing

enum `Buffer.Slab Occupancy Safety Tests` {}

extension `Buffer.Slab Occupancy Safety Tests` {
    @Suite
    struct `Buffer.Slab - Occupancy Safety` {

        @Test
        func `insert at an occupied slot traps instead of leaking the element`() async {
            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab(minimumCapacity: 4)
                buffer.insert(1, at: 1)
                buffer.insert(2, at: 1)
            }
        }

        @Test
        func `remove at a vacant slot traps instead of reading uninitialized memory`() async {
            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab(minimumCapacity: 4)
                buffer.insert(1, at: 0)
                _ = buffer.remove(at: 1)
            }
        }

        @Test
        func `update at a vacant slot traps instead of reading uninitialized memory`() async {
            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab(minimumCapacity: 4)
                buffer.insert(1, at: 0)
                _ = buffer.update(at: 1, with: 2)
            }
        }

        @Test
        func `reading a vacant slot traps instead of reading uninitialized memory`() async {
            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab(minimumCapacity: 4)
                buffer.insert(1, at: 0)
                _ = buffer[1]
            }
        }

        @Test
        func `reading a removed slot traps`() async {
            await #expect(processExitsWith: .failure) {
                var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab(minimumCapacity: 4)
                buffer.insert(1, at: 1)
                _ = buffer.remove(at: 1)
                _ = buffer[1]
            }
        }

        @Test
        func `occupied-slot operations still succeed`() {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Slab(minimumCapacity: 4)

            buffer.insert(1, at: 1)
            #expect(buffer[1] == 1)
            #expect(buffer.update(at: 1, with: 2) == 1)
            #expect(buffer.remove(at: 1) == 2)
            buffer.insert(3, at: 1)
            #expect(buffer[1] == 3)
        }
    }
}
