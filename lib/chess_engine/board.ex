defmodule ChessEngine.Board do
  alias ChessEngine.{Board, Piece, Position}

  @enforce_keys [
    :pieces_white,
    :pieces_black,
    :captured_pieces_white,
    :captured_pieces_black
  ]
  defstruct [
    :pieces_white,
    :pieces_black,
    :captured_pieces_white,
    :captured_pieces_black
  ]

  def new,
    do: %Board{
      pieces_white: %{},
      pieces_black: %{},
      captured_pieces_white: [],
      captured_pieces_black: []
    }

  def start_new, do: ChessEngine.Board.Setup.start_position(Board.new())

  def position_piece(board, {%Position{} = position, %Piece{color: :white} = piece}),
    do: put_in(board.pieces_white[position], piece)

  def position_piece(board, {%Position{} = position, %Piece{color: :black} = piece}),
    do: put_in(board.pieces_black[position], piece)

  def capture_piece(board, color, target_position) do
    piece = Board.find_piece(board, color, target_position)
    board = update_in(board.pieces_black, &Map.delete(&1, target_position))
    put_in(board.captured_pieces_black, piece)
  end

  def target_not_occupied_by_own_piece?(board, color, %Position{} = target_position) do
    case Board.find_piece(board, color, target_position) do
      :error -> true
      %Piece{} -> {false, :target_position_occupied_by_own_piece}
    end
  end

  def find_piece(board, :white, %Position{} = position),
    do: Map.get(board.pieces_white, position, :piece_not_found)

  def find_piece(board, :black, %Position{} = position),
    do: Map.get(board.pieces_black, position, :piece_not_found)

  def update_board(board, :white, current_position, target_position, piece) do
    board.pieces_white
    |> Map.delete(current_position)
    |> put_in([target_position], piece)
  end

  def update_board(board, :black, current_position, target_position, piece) do
    board.pieces_black
    |> Map.delete(current_position)
    |> put_in([target_position], piece)
  end
end
