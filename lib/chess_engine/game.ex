defmodule ChessEngine.Game do
  use GenServer

  alias ChessEngine.{Board, Move}

  @timeout_one_hour 3_600_000

  def start_link(name) when is_binary(name),
    do: GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  def via_tuple(name), do: {:via, Registry, {Registry.Game, name}}

  def init(name) do
    {:ok, %{board: Board.start_new()}}
  end
end
