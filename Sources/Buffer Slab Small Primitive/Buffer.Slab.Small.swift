extension Buffer.Slab where S: ~Copyable {

    @frozen
    public struct Small<let inlineCapacity: Int>: ~Copyable {
        @usableFromInline
        internal var _storage: _Representation

        @inlinable

        internal init(_storage: consuming _Representation) {
            self._storage = _storage
        }

    }
}

extension Buffer.Slab.Small where S: ~Copyable {

    @frozen @usableFromInline
    internal enum _Representation: ~Copyable {
        case inline(Buffer.Slab.Inline<inlineCapacity>)
        case heap(Buffer.Slab)
    }
}

extension Buffer.Slab.Small._Representation: @unsafe @unchecked Sendable
where S: ~Copyable, S: Sendable, S.Element: Sendable {}
extension Buffer.Slab.Small: Sendable where S: ~Copyable, S: Sendable, S.Element: Sendable {}
