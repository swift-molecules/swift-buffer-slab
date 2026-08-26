public import Buffer_Protocol

extension Buffer.Slab.Inline: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
