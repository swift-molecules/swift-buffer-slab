# swift-buffer-slab

Use this package when you need a fixed set of numbered slots that elements occupy sparsely: you choose the slot, an element stays at that slot until you remove it, and the buffer tracks which slots are occupied with a bitmap. Start from `Buffer<S>.Slab` for heap storage of a capacity chosen at creation, `Buffer<S>.Slab.Inline<wordCount>` for storage held inside the value, or `Buffer<S>.Slab.Small<inlineCapacity>` for inline storage that moves to the heap when it runs out. `Buffer<S>.Slab.Bounded` is heap storage like `Buffer<S>.Slab`, with an array initializer and `peek` in place of the subscript. If you track occupancy yourself in per-slot metadata, use swift-buffer-slots instead.

## Laws

- Slots are stable. Inserting, removing or updating one slot never moves an element in another slot. A removed slot can be reused.
- `firstVacant()` returns the lowest-numbered vacant slot, or `nil` when every slot is occupied.
- `Buffer<S>.Slab` and `Buffer<S>.Slab.Bounded` never grow. Their capacity is the capacity of the storage allocated at creation, which is at least the requested minimum.
- The array initializers put element `i` at slot `i`. They throw instead of truncating when the array has more elements than the capacity.
- `clone()` is a deep copy with the same capacity and the same occupied slots. Changes to the copy do not affect the original, and the reverse also holds.
- Teardown deinitializes each occupied element exactly once and leaves vacant slots alone. `removeAll()` and `drain` empty the buffer. `drain` hands each element to the closure as it removes it.
- `Buffer<S>.Slab.Inline<wordCount>` has `wordCount` slots, not `wordCount` words. `isOccupied(at:)` returns `false` for a slot past that limit. `insert`, `remove`, `update` and `peek` trap on such a slot.
- `Buffer<S>.Slab.Inline<wordCount>` iterates over a snapshot of the occupied elements, in ascending slot order, taken when the iterator is made.
- `Buffer<S>.Slab.Inline<wordCount>` and the inline mode of `Buffer<S>.Slab.Small<inlineCapacity>` work only in debug builds. In any other build configuration, every mutation (`insert`, `remove`, `update`, `removeAll`, `drain`, and the array initializer) traps on purpose. The reason is a compiler bug that drops the occupancy-bitmap write under optimization. Construction and read-only queries still work.
- `Buffer<S>.Slab.Small<inlineCapacity>` starts inline. An insert moves it to the heap when the inline slots are full or when the slot number is `inlineCapacity` or more. The heap capacity is at least the larger of the slot number plus one and twice `inlineCapacity`. Every element keeps its slot through the move.
- After the move, `Buffer<S>.Slab.Small<inlineCapacity>` stays on the heap and does not grow again. Removing elements does not bring it back inline. Only `removeAll()` and `drain` return it to empty inline storage.
- In inline mode, `Buffer<S>.Slab.Small<inlineCapacity>` returns `false` from `isOccupied(at:)` for a slot of `inlineCapacity` or more. `remove` and `update` trap on such a slot.
