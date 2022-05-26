defmodule ChessEngine.Gamestate do
  alias __MODULE__

  defstruct state: :initialized

  def new, do: %Gamestate{}

  def check(%Gamestate{state: :initialized} = gamestate, :add_player),
    do: {:ok, %Gamestate{state: :select_colors}}

  def check(%Gamestate{state: :select_colors} = gamestate, :select_colors),
    do: {:ok, %Gamestate{state: :player_white_turn}}

  def check(%Gamestate{state: :player_white_turn} = gamestate, {:move_piece, :player_white}),
    do: {:ok, %Gamestate{state: :player_black_turn}}

  def check(%Gamestate{state: :player1_turn} = gamestate, {:check_mate_or_not, check_mate_or_not}) do
    case check_mate_or_not do
      :no_check_mate -> {:ok, gamestate}
      :check_mate -> {:ok, %Gamestate{gamestate | state: :check_mate}}
    end
  end

  def check(%Gamestate{state: :player_black_turn} = gamestate, {:move_piece, :player_black}),
    do: {:ok, %Gamestate{state: :player_white_turn}}

  def check(
        %Gamestate{state: :player_black_turn} = gamestate,
        {:check_mate_or_not, check_mate_or_not}
      ) do
    case check_mate_or_not do
      :no_check_mate -> {:ok, gamestate}
      :check_mate -> {:ok, %Gamestate{gamestate | state: :check_mate}}
    end
  end

  def check(_state, _action), do: :error
end
