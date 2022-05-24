defmodule ChessEngine.Piece.Movements.Movesets do
  alias ChessEngine.Piece
  import ChessEngine.Piece.Movements

  def movements(%Piece{type: :pawn, color: :white}),
    do: [
      &top_one/1,
      &top_two/1,
      &diagonal_top_queenside_one/1,
      &diagonal_top_kingside_one/1
    ]

  def movements(%Piece{type: :pawn, color: :black}),
    do: [
      &bottom_one/1,
      &bottom_two/1,
      &diagonal_bottom_queenside_one/1,
      &diagonal_bottom_kingside_one/1
    ]

  def movements(%Piece{type: :king, color: :white}),
    do: [
      &queenside_one/1,
      &diagonal_top_queenside_one/1,
      &top_one/1,
      &diagonal_top_kingside_one/1,
      &kingside_one/1,
      &diagonal_bottom_kingside_one/1,
      &bottom_one/1,
      &diagonal_bottom_queenside_one/1,
      &castling_queenside_white/1,
      &castling_kingside_white/1
    ]

  def movements(%Piece{type: :king, color: :black}),
    do: [
      &queenside_one/1,
      &diagonal_top_queenside_one/1,
      &top_one/1,
      &diagonal_top_kingside_one/1,
      &kingside_one/1,
      &diagonal_bottom_kingside_one/1,
      &bottom_one/1,
      &diagonal_bottom_queenside_one/1,
      &castling_queenside_black/1,
      &castling_kingside_black/1
    ]

  def movements(%Piece{type: :rook}),
    do: [
      &horizontal_n/1,
      &vertical_n/1
    ]

  def movements(%Piece{type: :bishop}),
    do: [
      &diagonal_top_queenside_n/1,
      &diagonal_top_kingside_n/1,
      &diagonal_bottom_kingside_n/1,
      &diagonal_bottom_queenside_n/1
    ]

  def movements(%Piece{type: :queen}),
    do: [
      &horizontal_n/1,
      &vertical_n/1,
      &diagonal_top_queenside_n/1,
      &diagonal_top_kingside_n/1,
      &diagonal_bottom_kingside_n/1,
      &diagonal_bottom_queenside_n/1
    ]

  def movements(%Piece{type: :knight}),
    do: [
      &jump_queenside_top/1,
      &jump_top_queenside/1,
      &jump_top_kingside/1,
      &jump_kingside_top/1,
      &jump_kingside_bottom/1,
      &jump_bottom_kingside/1,
      &jump_bottom_queenside/1,
      &jump_queenside_bottom/1
    ]
end
