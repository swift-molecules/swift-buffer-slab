public import Buffer_Protocol_Primitives

extension Buffer.Slab: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
