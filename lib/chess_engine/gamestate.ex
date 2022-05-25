defmodule ChessEngine.Gamestate do
  alias __MODULE__

  defstruct state: :initialized

  def new, do: %Gamestate{}

  def check(%Gamestate{state: :initialized} = gamestate, :add_player),
    do: {:ok, %Gamestate{state: :player1_turn}}

  def check(%Gamestate{state: :player1_turn} = gamestate, {:move_piece, :player1}),
    do: {:ok, %Gamestate{state: :player2_turn}}

  def check(%Gamestate{state: :player1_turn} = gamestate, {:check_mate_or_not, check_mate_or_not}) do
    case check_mate_or_not do
      :no_check_mate -> {:ok, gamestate}
      :check_mate -> {:ok, %Gamestate{gamestate | state: :check_mate}}
    end
  end

  def check(%Gamestate{state: :player2_turn} = gamestate, {:move_piece, :player2}),
    do: {:ok, %Gamestate{state: :player1_turn}}

  def check(%Gamestate{state: :player2_turn} = gamestate, {:check_mate_or_not, check_mate_or_not}) do
    case check_mate_or_not do
      :no_check_mate -> {:ok, gamestate}
      :check_mate -> {:ok, %Gamestate{gamestate | state: :check_mate}}
    end
  end

  def check(_state, _action), do: :error
end
