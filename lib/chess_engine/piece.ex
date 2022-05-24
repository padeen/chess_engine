defmodule ChessEngine.Piece do
  alias __MODULE__
  alias ChessEngine.Position

  @enforce_keys [:type, :color, :position]
  defstruct [:type, :color, :position]

  @types [:king, :queen, :rook, :knight, :bishop, :pawn]
  @colors [:white, :black]

  def new(type, color, %Position{} = position) when color in @colors and type in @types do
    {:ok, %Piece{type: type, color: color, position: position}}
  end

  def new(_type, _position), do: {:error, :invalid_type}
end
