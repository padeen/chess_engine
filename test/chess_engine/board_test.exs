defmodule ChessEngine.BoardTest do
  use ExUnit.Case, async: true

  alias ChessEngine.{Board, Piece, Position}

  describe "move_piece/2" do
    test "moving piece to empty square should move the piece to the target square" do
      board = Board.start_new()
      {:ok, d2} = Position.new("d", 2)
      {:ok, d4} = Position.new("d", 4)
      pawn_d2 = Map.get(board.pieces_on_the_board, d2)
      board = Board.move_piece(board, {d2, d4})

      assert ^pawn_d2 = Map.get(board.pieces_on_the_board, d4)
    end

    test "after moving a piece the square of departure should be empty" do
      board = Board.start_new()
      {:ok, d2} = Position.new("d", 2)
      {:ok, d4} = Position.new("d", 4)
      board = Board.move_piece(board, {d2, d4})

      assert :empty_square = Map.get(board.pieces_on_the_board, d2, :empty_square)
    end

    test "moving piece to square occupied by enemy piece should put the enemy piece to captured pieces" do
      board = Board.new()
      {:ok, d1} = Position.new("d", 1)
      {:ok, d8} = Position.new("d", 8)
      {:ok, queen_white} = Piece.new(:white, :queen)
      {:ok, queen_black} = Piece.new(:black, :queen)

      board = Board.put_piece_on_board(board, {d1, queen_white})
      board = Board.put_piece_on_board(board, {d8, queen_black})
      board = Board.move_piece(board, {d1, d8})

      assert Enum.member?(board.captured_pieces_black, queen_black)
    end

    test "moving piece to square occupied by own piece should return error tuple" do
      board = Board.start_new()
      {:ok, d1} = Position.new("d", 1)
      {:ok, d2} = Position.new("d", 2)
      assert {:error, :square_occupied_by_own_piece} = Board.move_piece(board, {d1, d2})
    end

    test "selecting an empty square should return error tuple" do
      board = Board.start_new()
      {:ok, d4} = Position.new("d", 4)
      {:ok, d8} = Position.new("d", 8)
      assert {:error, :no_piece_on_current_position} = Board.move_piece(board, {d4, d8})
    end
  end

  test "put piece on board should add piece to pieces on the board" do
    board = Board.new()
    {:ok, d1} = Position.new("d", 1)
    {:ok, queen_white} = Piece.new(:white, :queen)
    board = Board.put_piece_on_board(board, {d1, queen_white})
    assert %Piece{} = Map.get(board.pieces_on_the_board, d1)
  end
end
