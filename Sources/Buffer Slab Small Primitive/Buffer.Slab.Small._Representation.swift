
extension Buffer.Slab.Small where S: ~Copyable {
    @frozen @usableFromInline
    internal enum _Representation: ~Copyable {
        case inline(Buffer.Slab.Inline<inlineCapacity>)
        case heap(Buffer.Slab)
    }
}
