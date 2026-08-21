import Buffer_Slab_Inline_Primitives
import Buffer_Slab_Primitives_Test_Support
import Finite_Bounded_Primitives
import Memory_Allocator_Primitive
import Memory_Heap_Primitives
import Storage_Contiguous_Primitives
import Testing

@Suite(
    .disabled(
        if: !_isDebugAssertConfiguration(),
        "release-blocked: swift-issue-inlinearray-class-field-write-elision; pending HANDOFF-sparse-occupancy-placement.md"
    )
)
struct `Buffer.Slab.Inline - Deinit` {

    final class Tracker: @unchecked Sendable {
        private var _storage: [Int] = []
    }

    struct TrackedElement: ~Copyable {
        let id: Int
        let tracker: Tracker
        init(_ id: Int, tracker: Tracker) {
            self.id = id
            self.tracker = tracker
        }
        deinit { tracker.append(id) }
    }

    private struct _BareWrapper<Element: ~Copyable, let wordCount: Int>: ~Copyable {
        var _buffer:
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Slab.Inline<
                wordCount
            >
        init() {
            self._buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Slab
                .Inline()
        }
        deinit {}
    }

    @Test
    func `deinit cleans up inline storage elements`() {
        let tracker = Tracker()
        do {
            var bare = _BareWrapper<TrackedElement, 4>()
            let s0: Bit.Index.Bounded<4> = 0
            let s1: Bit.Index.Bounded<4> = 1
            let s2: Bit.Index.Bounded<4> = 2
            bare._buffer.insert(TrackedElement(1, tracker: tracker), at: s0)
            bare._buffer.insert(TrackedElement(2, tracker: tracker), at: s1)
            bare._buffer.insert(TrackedElement(3, tracker: tracker), at: s2)
        }
        #expect(tracker.deinitOrder == [1, 2, 3])
    }
}

extension `Buffer.Slab.Inline - Deinit`.Tracker {
    var deinitOrder: [Int] { _storage }
    func append(_ id: Int) { _storage.append(id) }
}

@Suite(
    .disabled(
        if: !_isDebugAssertConfiguration(),
        "release-blocked: swift-issue-inlinearray-class-field-write-elision; pending HANDOFF-sparse-occupancy-placement.md"
    )
)
struct `Buffer.Slab.Inline - Single-Free` {

    final class Ledger: @unchecked Sendable {
        private var _counts: [Int: Int] = [:]
    }

    struct Counted: ~Copyable {
        let id: Int
        let ledger: Ledger
        init(_ id: Int, _ ledger: Ledger) {
            self.id = id
            self.ledger = ledger
        }
        deinit { ledger.record(id) }
    }

    @Test
    func `inline teardown frees each occupied slot exactly once`() {
        let ledger = Ledger()
        let n = 6
        do {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Counted>>.Slab
                .Inline<8>()
            (0..<n).forEach { i in
                buffer.insert(
                    Counted(i, ledger),
                    at: Bit.Index.Bounded<8>(Bit.Index(Ordinal(UInt(i))))!
                )
            }
        }
        #expect(ledger.total == n)
        #expect(ledger.maxPerID == 1)
        #expect(ledger.distinctIDs == n)
    }

    @Test
    func `sparse inline teardown frees only occupied slots, once each`() {
        let ledger = Ledger()
        do {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Counted>>.Slab
                .Inline<8>()
            let s0: Bit.Index.Bounded<8> = 0
            let s4: Bit.Index.Bounded<8> = 4
            let s7: Bit.Index.Bounded<8> = 7
            buffer.insert(Counted(1, ledger), at: s0)
            buffer.insert(Counted(2, ledger), at: s4)
            buffer.insert(Counted(3, ledger), at: s7)
        }
        #expect(ledger.total == 3)
        #expect(ledger.maxPerID == 1)
    }

    @Test
    func `remove then teardown never double-frees a removed slot`() {
        let ledger = Ledger()
        do {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Counted>>.Slab
                .Inline<8>()
            let s0: Bit.Index.Bounded<8> = 0
            let s1: Bit.Index.Bounded<8> = 1
            buffer.insert(Counted(1, ledger), at: s0)
            buffer.insert(Counted(2, ledger), at: s1)
            _ = buffer.remove(at: s0)
            #expect(ledger.total == 1)
            #expect(ledger.maxPerID == 1)
        }
        #expect(ledger.total == 2)
        #expect(ledger.maxPerID == 1)
    }
}

extension `Buffer.Slab.Inline - Single-Free`.Ledger {
    func record(_ id: Int) { _counts[id, default: 0] += 1 }
    var total: Int { _counts.values.reduce(0, +) }
    var maxPerID: Int { _counts.values.max() ?? 0 }
    var distinctIDs: Int { _counts.count }
}

@Suite
struct `Buffer.Slab.Header.Static - Release Isolation` {
    @Test
    func `local Header.Static bitmap set persists`() {
        var h = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Slab.Header.Static<
            8
        >()
        let s2: Bit.Index = Bit.Index(Ordinal(2 as UInt))
        h.bitmap[s2] = true
        #expect(h.isOccupied(at: s2) == true)
        #expect(h.occupancy == 1)
    }
}
