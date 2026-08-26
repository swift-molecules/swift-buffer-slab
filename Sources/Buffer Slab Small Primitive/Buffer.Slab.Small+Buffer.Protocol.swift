public import Buffer_Protocol

extension Buffer.Slab.Small: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
