import Buffer_Slab
import Buffer_Slab_Test_Support
import Memory_Allocator_Primitive
import Memory_Heap
import Memory_Small
import Storage_Contiguous
import Testing

@Suite
struct `Buffer.Slab.Bounded — DS-029 Small-column probe` {

    typealias SmallColumn = Storage<Memory.Allocator<Memory.Small<64>>>.Contiguous<Int>

    @Test
    func `construct, insert, remove, and occupancy-walk a Memory.Small<64> bounded column`() {

        var buffer = Buffer<SmallColumn>.Slab.Bounded(minimumCapacity: 8)
        buffer.insert(10, at: 0)
        buffer.insert(20, at: 2)
        buffer.insert(30, at: 5)

        #expect(buffer.occupancy == 3)

        var occupied = 0
        for raw in 0..<8 where buffer.isOccupied(at: Bit.Index(Ordinal(UInt(raw)))) {
            occupied += 1
        }
        #expect(occupied == 3)
        #expect(buffer.isOccupied(at: 0) == true)
        #expect(buffer.isOccupied(at: 1) == false)

        #expect(buffer.remove(at: 2) == 20)
        #expect(buffer.occupancy == 2)
        #expect(buffer.isOccupied(at: 2) == false)
    }

    @Test
    func `array-init then clone a Memory.Small<64> bounded column`() throws {

        var buffer = try Buffer<SmallColumn>.Slab.Bounded([10, 20, 30], capacity: 8)
        #expect(buffer.occupancy == 3)
        #expect(buffer.peek(at: 0) == 10)
        #expect(buffer.peek(at: 1) == 20)
        #expect(buffer.peek(at: 2) == 30)

        let copy = buffer.clone()
        #expect(copy.occupancy == 3)
        #expect(copy.peek(at: 0) == 10)

        _ = buffer.remove(at: 0)
        #expect(buffer.occupancy == 2)
        #expect(copy.occupancy == 3)
    }
}
