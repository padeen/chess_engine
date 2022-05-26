defmodule ChessEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Registry.Game},
      ChessEngine.GameSupervisor
    ]

    opts = [strategy: :one_for_one, name: ChessEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
