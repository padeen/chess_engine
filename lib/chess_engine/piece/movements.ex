defmodule ChessEngine.Piece.Movements do
  alias ChessEngine.Position

  import ChessEngine.Piece.Movements.BasicMoves

  def top_two(%Position{rank: 2} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
  end

  def bottom_two(%Position{rank: 7} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
  end

  def bottom_two(_position), do: []

  def queenside_one(%Position{} = position),
    do: Map.update!(position, :file, fn file -> shift_file_queenside(file) end)

  def top_one(%Position{} = position),
    do: Map.update!(position, :rank, fn rank -> shift_rank_to_top(rank) end)

  def kingside_one(%Position{} = position),
    do: Map.update!(position, :file, fn file -> shift_file_kingside(file) end)

  def bottom_one(%Position{} = position),
    do: Map.update!(position, :rank, fn rank -> shift_rank_to_bottom(rank) end)

  def diagonal_top_queenside_one(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
  end

  def diagonal_top_kingside_one(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
  end

  def diagonal_bottom_kingside_one(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
  end

  def diagonal_bottom_queenside_one(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
  end

  def horizontal_n(position) do
    Position.files()
    |> List.delete(position.file)
    |> Enum.map(fn file -> %Position{position | file: file} end)
  end

  def vertical_n(position) do
    Enum.to_list(Position.ranks())
    |> List.delete(position.rank)
    |> Enum.map(fn rank -> %Position{position | rank: rank} end)
  end

  def diagonal_top_queenside_n(position, positions \\ [])

  def diagonal_top_queenside_n(%Position{file: file, rank: rank}, positions)
      when file == "a" or rank == 8,
      do: positions

  def diagonal_top_queenside_n(%Position{} = position, positions) do
    new_position =
      position
      |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
      |> Map.update!(:file, fn file -> shift_file_queenside(file) end)

    diagonal_top_queenside_n(new_position, [new_position | positions])
  end

  def diagonal_top_kingside_n(position, positions \\ [])

  def diagonal_top_kingside_n(%Position{file: file, rank: rank}, positions)
      when file == "h" or rank == 8,
      do: positions

  def diagonal_top_kingside_n(%Position{} = position, positions) do
    new_position =
      position
      |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
      |> Map.update!(:file, fn file -> shift_file_kingside(file) end)

    diagonal_top_kingside_n(new_position, [new_position | positions])
  end

  def diagonal_bottom_kingside_n(position, positions \\ [])

  def diagonal_bottom_kingside_n(%Position{file: file, rank: rank}, positions)
      when file == "h" or rank == 1,
      do: positions

  def diagonal_bottom_kingside_n(%Position{} = position, positions) do
    new_position =
      position
      |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
      |> Map.update!(:file, fn file -> shift_file_kingside(file) end)

    diagonal_bottom_kingside_n(new_position, [new_position | positions])
  end

  def diagonal_bottom_queenside_n(position, positions \\ [])

  def diagonal_bottom_queenside_n(%Position{file: file, rank: rank}, positions)
      when file == "a" or rank == 1,
      do: positions

  def diagonal_bottom_queenside_n(%Position{} = position, positions) do
    new_position =
      position
      |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
      |> Map.update!(:file, fn file -> shift_file_queenside(file) end)

    diagonal_bottom_queenside_n(new_position, [new_position | positions])
  end

  def castling_queenside_white(%Position{file: "e", rank: 1} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
  end

  def castling_queenside_black(%Position{file: "e", rank: 8} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
  end

  def castling_kingside_white(%Position{file: "e", rank: 1} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
  end

  def castling_kingside_black(%Position{file: "e", rank: 8} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
  end

  def castling({:king, _color, _position}), do: []

  def jump_queenside_top(%Position{} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
  end

  def jump_top_queenside(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
  end

  def jump_top_kingside(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
  end

  def jump_kingside_top(%Position{} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_top(rank) end)
  end

  def jump_kingside_bottom(%Position{} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
  end

  def jump_bottom_kingside(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
    |> Map.update!(:file, fn file -> shift_file_kingside(file) end)
  end

  def jump_bottom_queenside(%Position{} = position) do
    position
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
  end

  def jump_queenside_bottom(%Position{} = position) do
    position
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
    |> Map.update!(:file, fn file -> shift_file_queenside(file) end)
    |> Map.update!(:rank, fn rank -> shift_rank_to_bottom(rank) end)
  end
end
