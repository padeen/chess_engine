defmodule ChessEngine.Board do
  alias ChessEngine.{Board, Piece, Position}

  @enforce_keys [:pieces_white, :pieces_black, :captured_white_pieces, :captured_black_pieces]
  defstruct [:pieces_white, :pieces_black, :captured_white_pieces, :captured_black_pieces]

  def new,
    do: %Board{
      pieces_white: [],
      pieces_black: [],
      captured_white_pieces: [],
      captured_black_pieces: []
    }

  def start_new, do: ChessEngine.Board.Setup.start_position(Board.new())

  def position_piece(board, %Piece{color: :white} = piece),
    do: update_in(board.pieces_white, &[piece | &1])

  def position_piece(board, %Piece{color: :black} = piece),
    do: update_in(board.pieces_black, &[piece | &1])

  def capture_piece(board, color, target_position) do
    piece = find_piece(board, color, target_position)
    board = update_in(board.pieces_black, &List.delete(&1, piece))
    piece = %Piece{piece | position: nil}
    update_in(board.captured_black_pieces, &[piece | &1])
  end

  def find_piece(board, :white, %Position{} = position),
    do:
      Enum.find(board.pieces_white, :piece_not_found, fn piece -> piece.position == position end)

  def find_piece(board, :black, %Position{} = position),
    do:
      Enum.find(board.pieces_black, :piece_not_found, fn piece -> piece.position == position end)
end
