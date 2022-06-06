defmodule ChessEngine.Board.Setup do
  alias ChessEngine.{Position, Piece}

  import ChessEngine.Board

  @files Position.files()

  @pieces ~w[rook knight bishop queen king bishop knight rook]a

  def start_position(board) do
    board
    |> set_pawns(:white)
    |> set_pawns(:black)
    |> set_other_pieces(:white)
    |> set_other_pieces(:black)
  end

  defp set_pawns(board, :white) do
    @files
    |> Enum.map(fn file -> {create_position(file, 2), create_piece(:white, :pawn)} end)
    |> Enum.reduce(board, fn {position, pawn}, board ->
      put_piece_on_board(board, {position, pawn})
    end)
  end

  defp set_pawns(board, :black) do
    @files
    |> Enum.map(fn file -> {create_position(file, 7), create_piece(:black, :pawn)} end)
    |> Enum.reduce(board, fn {position, pawn}, board ->
      put_piece_on_board(board, {position, pawn})
    end)
  end

  defp set_other_pieces(board, :white) do
    @files
    |> Enum.zip(@pieces)
    |> Enum.map(fn {file, type} -> {create_position(file, 1), create_piece(:white, type)} end)
    |> Enum.reduce(board, fn {position, piece}, board ->
      put_piece_on_board(board, {position, piece})
    end)
  end

  defp set_other_pieces(board, :black) do
    @files
    |> Enum.zip(@pieces)
    |> Enum.map(fn {file, type} -> {create_position(file, 8), create_piece(:black, type)} end)
    |> Enum.reduce(board, fn {position, piece}, board ->
      put_piece_on_board(board, {position, piece})
    end)
  end

  defp create_position(file, rank) do
    {:ok, position} = Position.new(file, rank)
    position
  end

  defp create_piece(color, type) do
    {:ok, piece} = Piece.new(color, type)
    piece
  end
end
