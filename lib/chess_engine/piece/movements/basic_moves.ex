defmodule ChessEngine.Piece.Movements.BasicMoves do
  alias ChessEngine.Position

  def shift_rank_to_top(rank),
    do: rank + 1

  def shift_rank_to_bottom(rank),
    do: rank - 1

  def shift_file_queenside(file) do
    files = Position.files()
    find_next_file_queenside = &Enum.at(files, &1 - 1)

    files
    |> Enum.find_index(fn elem -> elem == file end)
    |> find_next_file_queenside.()
  end

  def shift_file_kingside(file) do
    files = Position.files()
    find_next_file_kingside = &Enum.at(files, &1 + 1)

    files
    |> Enum.find_index(fn elem -> elem == file end)
    |> find_next_file_kingside.()
  end
end
