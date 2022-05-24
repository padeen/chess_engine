defmodule ChessEngine.Position do
  alias __MODULE__

  @enforce_keys [:rank, :file]
  defstruct [:rank, :file]

  @files ["a", "b", "c", "d", "e", "f", "g", "h"]
  @ranks 1..8

  def new(file, rank) when file in @files and rank in @ranks,
    do: {:ok, %Position{file: file, rank: rank}}

  def new(_file, _rank), do: {:error, :invalid_position}

  def files, do: @files
  def ranks, do: @ranks
end
