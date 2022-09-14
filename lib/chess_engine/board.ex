defmodule ChessEngine.Board do
  alias ChessEngine.{Board, Piece, Position}
  alias ChessEngine.Piece.Movements.Movesets

  @enforce_keys [
    :pieces_on_the_board,
    :captured_pieces_white,
    :captured_pieces_black
  ]
  defstruct [
    :pieces_on_the_board,
    :captured_pieces_white,
    :captured_pieces_black
  ]

  def new,
    do: %Board{
      pieces_on_the_board: %{},
      captured_pieces_white: [],
      captured_pieces_black: []
    }

  def start_new, do: ChessEngine.Board.Setup.start_position(Board.new())

  def put_piece_on_board(board, {%Position{} = position, %Piece{} = piece}) do
    put_in(board.pieces_on_the_board[position], piece)
  end

  def move_piece(
        board,
        %Position{} = current_position,
        %Position{} = target_position
      )
      when current_position != target_position do
    with %Piece{color: color} = piece <- find_piece(board, current_position),
         true <- square_not_occupied_by_own_piece?(board, color, target_position),
         true <- not_check?(board, color, target_position) do
      opponent_color = opponent_color(color)

      board =
        case square_is_empty?(board, target_position) do
          %Piece{color: ^opponent_color} = piece -> capture_piece(board, piece, target_position)
          true -> board
        end

      update_position_on_board(board, current_position, target_position, piece)
    else
      :piece_not_found -> {:error, :no_piece_on_current_position}
      false -> {:error, :square_occupied_by_own_piece}
      :king_is_checked -> :king_is_checked
    end
  end

  def move_piece(_board, _current_position, _target_position), do: {:error, :piece_not_moved}

  def find_piece(board, %Position{} = position),
    do: Map.get(board.pieces_on_the_board, position, :piece_not_found)

  def square_is_empty?(board, %Position{} = position),
    do: Map.get(board.pieces_on_the_board, position, true)

  defp capture_piece(board, %Piece{color: :white} = enemy_piece, target_position) do
    board =
      update_in(board.captured_pieces_white, fn captured_pieces_white ->
        [enemy_piece | captured_pieces_white]
      end)

    update_in(board.pieces_on_the_board, &Map.delete(&1, target_position))
  end

  defp capture_piece(board, %Piece{color: :black} = enemy_piece, target_position) do
    board =
      update_in(board.captured_pieces_black, fn captured_pieces_black ->
        [enemy_piece | captured_pieces_black]
      end)

    update_in(board.pieces_on_the_board, &Map.delete(&1, target_position))
  end

  defp square_not_occupied_by_own_piece?(board, color, %Position{} = target_position) do
    case Board.find_piece(board, target_position) do
      %Piece{color: ^color} -> false
      _ -> true
    end
  end

  defp opponent_color(:white), do: :black
  defp opponent_color(:black), do: :white

  defp not_check?(_board, _color, %Position{} = _target_position) do
    true
  end

  defp movement_in_moveset?(
         %Piece{} = piece,
         %Position{} = _current_position,
         %Position{} = target_position
       ) do
    Enum.any?(Movesets.movements(piece), fn movement ->
      cond do
        is_list(movement) ->
          Enum.member?(movement, target_position)

        is_map(movement) ->
          movement == target_position
      end
    end)
  end

  defp update_position_on_board(board, current_position, target_position, piece) do
    pieces_on_the_board =
      board.pieces_on_the_board
      |> Map.delete(current_position)
      |> put_in([target_position], piece)

    %Board{board | pieces_on_the_board: pieces_on_the_board}
  end
end
