defmodule ChessEngine.Move do
  alias ChessEngine.{Board, Piece, Position}
  alias ChessEngine.Piece.Movements.Movesets

  def move_piece(
        %Board{} = board,
        color,
        current_position,
        target_position
      ) do
    #  true <- Board.target_not_occupied_by_own_piece?(board, color, target_position) do
    with %Piece{} = piece <- Board.find_piece(board, color, current_position) do
      case movement_in_moveset?(piece, target_position) do
        true ->
          case Board.capture_piece(board, color, target_position) do
            true -> :captured_opponent_piece
            false -> :no_capture
          end

          Board.update_board(board, color, current_position, target_position, piece)

        false ->
          {:movement_not_in_moveset, current_position}
      end
    else
      :piece_not_found ->
        {:error, :piece_not_found}

      {false, :target_position_occupied_by_own_piece} ->
        {:error, :target_position_occupied_by_own_piece}
    end
  end

  defp movement_in_moveset?(
         %Piece{} = piece,
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
end
