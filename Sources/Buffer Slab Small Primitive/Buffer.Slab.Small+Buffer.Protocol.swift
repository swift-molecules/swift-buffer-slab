public import Buffer_Protocol_Primitives

extension Buffer.Slab.Small: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
