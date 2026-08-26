public import Buffer_Protocol

extension Buffer.Slab: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
