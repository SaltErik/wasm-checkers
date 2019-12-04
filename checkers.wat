(module
  (memory $mem 1)
  ;; Globals (Game)
  (global $BLACK i32 (i32.const 1))
  (global $WHITE i32 (i32.const 2))
  (global $CROWN i32 (i32.const 4))
  ;; Globals (Helpers)
  (global $FOURBYTES i32 (i32.const 4))
  (global $LINEARIZE i32 (i32.const 8))
  ;; Returns the index for a given position
  (func $indexForPosition (param $x i32) (param $y i32) (result i32)
    (i32.add
      (i32.mul
        (get_global $LINEARIZE)
        (get_local $y)
      )
      (get_local $x)
    )
  )
  ;; Offset = (x + y * 8) * 4
  (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
    (i32.mul
      (call $indexForPosition
        (get_local $x)
        (get_local $y)
      )
      (get_global $FOURBYTES)
    )
  )
  ;; Determine if a piece is white
  (func $isWhite (param $piece i32) (result i32)
    (i32.eq
      (i32.and
        (get_local $piece)
        (get_global $WHITE)
      )
      (get_global $WHITE)
    )
  )
  ;; Determine if a piece is black
  (func $isBlack (param $piece i32) (result i32)
    (i32.eq
      (i32.and
        (get_local $piece)
        (get_global $BLACK)
      )
      (get_global $BLACK)
    )
  )
  ;; Determine if a piece has been crowned
  (func $isCrowned (param $piece i32) (result i32)
    (i32.eq
      (i32.and
        (get_local $piece)
        (get_global $CROWN)
      )
      (get_global $CROWN)
    )
  )
  ;; Add crown to a given piece (no mutation)
  (func $addCrown (param $piece i32) (result i32)
    (i32.or
      (get_local $piece)
      (get_global $CROWN)
    )
  )
  ;; Remove crown from a given piece (no mutation)
  (func $removeCrown (param $piece i32) (result i32)
    (i32.and
      (get_local $piece)
      (i32.const 3)
    )
  )
  ;; Detect if values are within range (high- and low inclusive)
  (func $inRange (param $low i32) (param $high i32) (param $value i32) (result i32)
    (i32.and
      (i32.ge_s
        (get_local $value)
        (get_local $low)
      )
      (i32.le_s
        (get_local $value)
        (get_local $high)
      )
    )
  )
    ;; Sets a piece on the board
  (func $setPiece (param $x i32) (param $y i32) (param $piece i32)
    (i32.store
      (call $offsetForPosition
        (get_local $x)
        (get_local $y)
      )
      (get_local $piece)
    )
  )
  ;; Gets a piece from the board (out-of-range causes a trap!)
  (func $getPiece (param $x i32) (param $y i32) (result i32)
    (if (result i32)
      (block (result i32)
        (i32.and
          (call $inRange
            (i32.const 0)
            (i32.const 7)
            (get_local $x)
          )
          (call $inRange
            (i32.const 0)
            (i32.const 7)
            (get_local $y)
          )
        )
      )
      (then
        (i32.load
          (call $offsetForPosition
            (get_local $x)
            (get_local $y)
          )
        )
      )
      (else
        (unreachable)
      )
    )
  )
  ;; Module exports
  (export "indexForPosition" (func $indexForPosition))
  (export "offsetForPosition" (func $offsetForPosition))
  (export "isCrowned" (func $isCrowned))
  (export "isWhite" (func $isWhite))
  (export "isBlack" (func $isBlack))
  (export "addCrown" (func $addCrown))
  (export "removeCrown" (func $removeCrown))
  (export "inRange" (func $inRange))
  (export "getPiece" (func $getPiece))
  (export "setPiece" (func $setPiece))
)