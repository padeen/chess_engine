defmodule ChessEngine.GameSupervisor do
  use Supervisor

  alias ChessEngine.Game

  def start_link(_options), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def start_game(name), do: Supervisor.start_child(__MODULE__, [name])

  def stop_game(name), do: Supervisor.terminate_child(__MODULE__, pid_from_name(name))

  def init(:ok) do
    Supervisor.init([Game], strategy: :simple_one_for_one)
  end

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.wheris()
  end
end
