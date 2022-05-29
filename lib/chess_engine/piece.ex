defmodule ChessEngine.Piece do
  alias __MODULE__
  alias ChessEngine.Position

  @enforce_keys [:type, :color]
  defstruct [:type, :color]

  @types ~w[king queen rook knight bishop pawn]a
  @colors [:white, :black]

  def new(type, color) when color in @colors and type in @types do
    {:ok, %Piece{type: type, color: color}}
  end

  def new(_type, _position), do: {:error, :invalid_type}
end
