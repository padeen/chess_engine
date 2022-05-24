defmodule ChessEngine.Board.Setup do
  alias ChessEngine.{Position, Piece}

  import ChessEngine.Board

  @files Position.files()

  @pieces %{
    a: :rook,
    b: :knight,
    c: :bishop,
    d: :queen,
    e: :king,
    f: :bishop,
    g: :knight,
    h: :rook
  }

  def start_position(board) do
    board
    |> set_pawns(:white)
    |> set_pawns(:black)
    |> set_other_pieces(:white)
    |> set_other_pieces(:black)
  end

  defp set_pawns(board, :white) do
    @files
    |> Enum.map(fn file -> create_position(file, 2) end)
    |> Enum.map(fn position -> create_piece(:pawn, :white, position) end)
    |> Enum.reduce(board, fn pawn, board -> position_piece(board, pawn) end)
  end

  defp set_pawns(board, :black) do
    @files
    |> Enum.map(fn file -> create_position(file, 7) end)
    |> Enum.map(fn position -> create_piece(:pawn, :black, position) end)
    |> Enum.reduce(board, fn pawn, board -> position_piece(board, pawn) end)
  end

  defp set_other_pieces(board, :white) do
    Enum.reduce(@pieces, board, fn {file, type}, board ->
      position = create_position(to_string(file), 1)
      position_piece(board, create_piece(type, :white, position))
    end)
  end

  defp set_other_pieces(board, :black) do
    Enum.reduce(@pieces, board, fn {file, type}, board ->
      position = create_position(to_string(file), 8)
      position_piece(board, create_piece(type, :black, position))
    end)
  end

  defp create_position(file, rank) do
    {:ok, position} = Position.new(file, rank)
    position
  end

  defp create_piece(type, color, position) do
    {:ok, piece} = Piece.new(type, color, position)
    piece
  end
end
