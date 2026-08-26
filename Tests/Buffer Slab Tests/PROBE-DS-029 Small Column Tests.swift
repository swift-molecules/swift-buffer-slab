import Buffer_Slab
import Buffer_Slab_Test_Support
import Memory_Allocator_Primitive
import Memory_Heap
import Memory_Small
import Storage_Contiguous
import Testing

@Suite
struct `Buffer.Slab — DS-029 Small-column probe` {

    typealias SmallColumn = Storage<Memory.Allocator<Memory.Small<64>>>.Contiguous<Int>

    @Test
    func `construct, insert, remove, and occupancy-walk a Memory.Small<64> column`() {

        var buffer = Buffer<SmallColumn>.Slab(minimumCapacity: 8)
        buffer.insert(10, at: 0)
        buffer.insert(20, at: 2)
        buffer.insert(30, at: 5)

        #expect(buffer.occupancy == 3)

        var seen: [Bit.Index] = []
        buffer.occupiedSlots.forEach { seen.append($0) }
        #expect(seen.count == 3)
        #expect(buffer.isOccupied(at: 0) == true)
        #expect(buffer.isOccupied(at: 1) == false)
        #expect(buffer.isOccupied(at: 2) == true)
        #expect(buffer.isOccupied(at: 5) == true)

        #expect(buffer.remove(at: 2) == 20)
        #expect(buffer.occupancy == 2)
        #expect(buffer.isOccupied(at: 2) == false)
    }

    @Test
    func `clone a Memory.Small<64> column`() {

        var original = Buffer<SmallColumn>.Slab(minimumCapacity: 8)
        original.insert(10, at: 0)
        original.insert(20, at: 3)

        var copy = original.clone()
        #expect(copy.occupancy == 2)
        #expect(copy[Bit.Index(Ordinal(0 as UInt))] == 10)
        #expect(copy[Bit.Index(Ordinal(3 as UInt))] == 20)

        copy.insert(99, at: 6)
        #expect(original.isOccupied(at: 6) == false)
        #expect(original.occupancy == 2)
    }
}
