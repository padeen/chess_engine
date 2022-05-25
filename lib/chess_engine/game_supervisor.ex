defmodule ChessEngine.DynamicSupervisor do
  use DynamicSupervisor

  alias ChessEngine.Game

  def start_link(_options), do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def start_game(name), do: DynamicSupervisor.start_child(__MODULE__, [name])

  def stop_game(name), do: DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(name))

  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [Game]
    )
  end

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.wheris()
  end
end
