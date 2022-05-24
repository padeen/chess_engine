defmodule ChessEngine.ScoreSheet do
  alias __MODULE__
  alias ChessEngine.Position

  @enforce_keys [:moves_white, :moves_black]
  defstruct [:moves_white, :moves_black]

  def new, do: %ScoreSheet{moves_white: [], moves_black: []}

  def add(%ScoreSheet{} = score_sheet, turn, :white, %Position{} = destination),
    do: score_sheet.moves_white ++ [destination]

  def add(%ScoreSheet{} = score_sheet, turn, :black, %Position{} = destination),
    do: score_sheet.moves_black ++ [destination]
end
