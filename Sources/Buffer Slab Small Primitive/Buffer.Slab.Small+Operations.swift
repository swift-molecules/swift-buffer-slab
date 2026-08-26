import Affine_Standard_Library_Integration
public import Finite_Bounded
public import Memory_Allocator_Primitive
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous
import Storage_Protocol

extension Buffer.Slab.Small where S: ~Copyable {

    @inlinable
    public init() {
        self.init(
            _storage: .inline(Buffer.Slab.Inline<inlineCapacity>())
        )
    }

    @inlinable
    public var isSpilled: Bool {
        switch _storage {
        case .heap: return true
        case .inline: return false
        }
    }

    @inlinable
    public var occupancy: Bit.Index.Count {
        switch _storage {
        case .heap(let buf): return buf.occupancy
        case .inline(let buf): return buf.occupancy
        }
    }

    @inlinable
    public var count: Index<Element>.Count { occupancy.retag(Element.self) }

    @inlinable
    public var isEmpty: Bool {
        switch _storage {
        case .heap(let buf): return buf.isEmpty
        case .inline(let buf): return buf.isEmpty
        }
    }

    @inlinable
    public var isFull: Bool {
        switch _storage {
        case .heap(let buf): return buf.isFull
        case .inline(let buf): return buf.isFull
        }
    }

    @inlinable
    public func isOccupied(at slot: Bit.Index) -> Bool {
        switch _storage {

        case .heap(let buf): return buf.isOccupied(at: slot)

        case .inline(let buf):
            guard let bounded = Bit.Index.Bounded<inlineCapacity>(slot) else {
                return false
            }
            return buf.isOccupied(at: bounded)
        }
    }

    @inlinable
    public func firstVacant() -> Bit.Index? {
        switch _storage {
        case .heap(let buf): return buf.firstVacant()
        case .inline(let buf): return buf.firstVacant().map { Bit.Index($0) }
        }
    }

    @inlinable
    public mutating func insert<E>(_ element: consuming E, at slot: Bit.Index)
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        switch _storage {
        case .heap(var buf):
            buf.insert(consume element, at: slot)
            self = Self(_storage: .heap(consume buf))

        case .inline(var buf):
            if !buf.isFull, let bounded = Bit.Index.Bounded<inlineCapacity>(slot) {
                buf.insert(consume element, at: bounded)
                self = Self(_storage: .inline(consume buf))
            } else {
                self = Self(_storage: .inline(consume buf))
                _spillToHeapMoving(coveringAtLeast: slot)
                guard case .heap(var buf) = _storage else {
                    fatalError("expected heap mode after spill")
                }
                buf.insert(consume element, at: slot)
                self = Self(_storage: .heap(consume buf))
            }
        }
    }

    @inlinable
    public mutating func remove(at slot: Bit.Index) -> S.Element {
        switch _storage {
        case .heap(var buf):
            let element = buf.remove(at: slot)
            self = Self(_storage: .heap(consume buf))
            return element

        case .inline(var buf):
            guard let bounded = Bit.Index.Bounded<inlineCapacity>(slot) else {
                preconditionFailure("slot exceeds inlineCapacity — never occupiable in inline mode")
            }
            let element = buf.remove(at: bounded)
            self = Self(_storage: .inline(consume buf))
            return element
        }
    }

    @inlinable
    public mutating func update(at slot: Bit.Index, with element: consuming S.Element) -> S.Element
    {
        switch _storage {
        case .heap(var buf):
            let old = buf.update(at: slot, with: consume element)
            self = Self(_storage: .heap(consume buf))
            return old

        case .inline(var buf):
            guard let bounded = Bit.Index.Bounded<inlineCapacity>(slot) else {
                preconditionFailure("slot exceeds inlineCapacity — never occupiable in inline mode")
            }
            let old = buf.update(at: bounded, with: consume element)
            self = Self(_storage: .inline(consume buf))
            return old
        }
    }

    @inlinable
    public mutating func removeAll() {
        switch _storage {
        case .heap(var buf):
            buf.removeAll()
            self = Self(_storage: .inline(Buffer.Slab.Inline<inlineCapacity>()))
            _ = consume buf

        case .inline(var buf):
            buf.removeAll()
            self = Self(_storage: .inline(consume buf))
        }
    }

    @usableFromInline
    mutating func _spillToHeapMoving<E>(coveringAtLeast slot: Bit.Index)
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        switch _storage {
        case .heap(let buf):
            self = Self(_storage: .heap(consume buf))
            return

        case .inline(var buf):
            let requiredForSlot = Int(slot.underlying.rawValue + 1)
            let newCapacity = Index<E>.Count(UInt(Swift.max(requiredForSlot, inlineCapacity * 2)))
            var heap = Buffer.Slab(minimumCapacity: newCapacity)

            var slot: Bit.Index = .zero
            let end = Bit.Index.Count(UInt(inlineCapacity)).map(Ordinal.init)
            while slot < end {
                guard let bounded = Bit.Index.Bounded<inlineCapacity>(slot) else {
                    preconditionFailure("slot exceeds inlineCapacity")
                }
                if buf.isOccupied(at: bounded) {
                    heap.insert(buf.remove(at: bounded), at: slot)
                }
                slot += .one
            }

            self = Self(_storage: .heap(consume heap))

        }
    }
}

extension Buffer.Slab.Small: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        switch _storage {
        case .heap(var buf):
            buf.drain(body)
            self = Self(_storage: .inline(Buffer.Slab.Inline<inlineCapacity>()))
            _ = consume buf

        case .inline(var buf):
            buf.drain(body)
            self = Self(_storage: .inline(consume buf))
        }
    }
}

extension Buffer.Slab.Small where S: ~Copyable {

    @inlinable
    public var drain: Property<Sequence.Drain, Self>.Inout {
        mutating _read {
            yield Property<Sequence.Drain, Self>.Inout(&self)
        }
        mutating _modify {
            var accessor = Property<Sequence.Drain, Self>.Inout(&self)
            yield &accessor
        }
    }
}
