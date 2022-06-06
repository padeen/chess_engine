defmodule ChessEngine.Piece do
  alias __MODULE__
  alias ChessEngine.Position

  @enforce_keys [:color, :type]
  defstruct [:color, :type]

  @colors [:white, :black]
  @types ~w[king queen rook knight bishop pawn]a

  def new(color, type) when color in @colors and type in @types do
    {:ok, %Piece{color: color, type: type}}
  end

  def new(_type, _position), do: {:error, :invalid_type}
end
