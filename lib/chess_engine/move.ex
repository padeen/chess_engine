defmodule ChessEngine.Move do
  alias ChessEngine.{Board, Piece, Position}
  alias ChessEngine.Piece.Movements.Movesets

  def move_piece(
        %Board{} = board,
        color,
        current_file,
        current_rank,
        target_file,
        target_rank
      ) do
    with {:ok, current_position} <- Position.new(current_file, current_rank),
         {:ok, target_position} <- Position.new(target_file, target_rank),
         %Piece{} = piece <- Board.find_piece(board, color, current_position),
         true <- target_not_occupied_by_own_piece?(board, color, target_position) do
      case movement_in_moveset?(piece, %Position{} = target_position) do
        true ->
          case Board.capture_piece(board, color, target_position) do
            true -> :captured_opponent_piece
            false -> :no_capture
          end

          update_board(board, color, current_position, target_position)

        false ->
          {:movement_not_in_moveset, current_position}
      end
    else
      {:error, :invalid_position} ->
        {:error, :invalid_position}

      :piece_not_found ->
        {:error, :piece_not_found}

      {false, :target_position_occupied_by_own_piece} ->
        {:error, :target_position_occupied_by_own_piece}
    end
  end

  defp target_not_occupied_by_own_piece?(board, color, %Position{} = target_position) do
    case Board.find_piece(board, color, target_position) do
      :piece_not_found -> true
      %Piece{} -> {false, :target_position_occupied_by_own_piece}
    end
  end

  defp movement_in_moveset?(
         %Piece{position: current_position} = piece,
         %Position{} = target_position
       ) do
    Enum.any?(Movesets.movements(piece), fn movement ->
      cond do
        is_list(movement.(current_position)) ->
          Enum.member?(movement.(current_position), target_position)

        is_map(movement.(current_position)) ->
          movement.(current_position) == target_position
      end
    end)
  end

  defp update_board(board, :white, current_position, target_position) do
    update_in(
      board.pieces_white,
      &Enum.map(&1, fn piece ->
        if piece.position == current_position,
          do: %Piece{piece | position: target_position},
          else: piece
      end)
    )
  end

  defp update_board(board, :black, current_position, target_position) do
    update_in(
      board.pieces_black,
      &Enum.map(&1, fn piece ->
        if piece.position == current_position,
          do: %Piece{piece | position: target_position},
          else: piece
      end)
    )
  end
end
