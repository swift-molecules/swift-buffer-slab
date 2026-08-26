import Buffer_Slab
import Buffer_Slab_Test_Support
import Memory_Allocator_Primitive
import Memory_Heap
import Storage_Contiguous
import Testing

@Suite
struct `Buffer.Slab Clone & Teardown` {

    @Test
    func `clone preserves the occupied slots`() {
        var original = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 8
        )
        original.insert(10, at: 0)
        original.insert(20, at: 3)
        original.insert(30, at: 7)

        let copy = original.clone()
        #expect(copy.occupancy == 3)
        #expect(copy[Bit.Index(Ordinal(0 as UInt))] == 10)
        #expect(copy[Bit.Index(Ordinal(3 as UInt))] == 20)
        #expect(copy[Bit.Index(Ordinal(7 as UInt))] == 30)

        #expect(original.occupancy == 3)
    }

    @Test
    func `clone yields an independent copy`() {
        var original = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 8
        )
        original.insert(10, at: 0)
        original.insert(20, at: 3)

        var copy = original.clone()

        #expect(copy.occupancy == 2)
        #expect(copy[Bit.Index(Ordinal(0 as UInt))] == 10)
        #expect(copy[Bit.Index(Ordinal(3 as UInt))] == 20)

        copy.insert(77, at: 5)
        _ = copy.remove(at: 0)
        #expect(original.isOccupied(at: 5) == false)
        #expect(original.isOccupied(at: 0) == true)
        #expect(original.occupancy == 2)

        original.insert(99, at: 6)
        #expect(copy.isOccupied(at: 6) == false)
    }

    @Test
    func `clone of an empty slab is empty`() {
        let original = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 4
        )
        let copy = original.clone()
        #expect(copy.isEmpty == true)
        #expect(copy.occupancy == .zero)
    }

    @Test
    func `original and clone each free exactly once`() {

        var original = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 4
        )
        original.insert(10, at: 0)
        original.insert(20, at: 2)
        do {
            let copy = original.clone()
            #expect(copy.occupancy == 2)
        }

        #expect(original.occupancy == 2)
    }

    @Test
    func `Bounded clone preserves the occupied slots`() {
        var original = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab.Bounded(
            minimumCapacity: 8
        )
        original.insert(10, at: 0)
        original.insert(20, at: 3)

        let copy = original.clone()
        #expect(copy.occupancy == 2)
        #expect(copy.peek(at: 0) == 10)
        #expect(copy.peek(at: 3) == 20)
        #expect(original.occupancy == 2)
    }

    @Test
    func `bitmap stays synced after insert-remove cycle`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 8
        )
        buffer.insert(10, at: 0)
        buffer.insert(20, at: 1)
        buffer.insert(30, at: 2)
        _ = buffer.remove(at: 1)

        #expect(buffer.occupancy == 2)
        #expect(buffer.isOccupied(at: 0) == true)
        #expect(buffer.isOccupied(at: 1) == false)
        #expect(buffer.isOccupied(at: 2) == true)
    }

    @Test
    func `bitmap stays synced after removeAll`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 8
        )
        buffer.insert(10, at: 0)
        buffer.insert(20, at: 3)
        buffer.removeAll()

        #expect(buffer.isEmpty == true)
        #expect(buffer.occupancy == .zero)
    }

    @Test
    func `bitmap stays synced after drain`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 8
        )
        buffer.insert(10, at: 0)
        buffer.insert(20, at: 3)
        buffer.drain { _ in }

        #expect(buffer.isEmpty == true)
    }

    @Test
    func `update preserves the new value`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab(
            minimumCapacity: 8
        )
        buffer.insert(10, at: 0)
        _ = buffer.update(at: 0, with: 99)
        #expect(buffer[Bit.Index(Ordinal(0 as UInt))] == 99)
    }
}
