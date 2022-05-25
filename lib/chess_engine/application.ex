defmodule ChessEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Registry.Game},
      {DynamicSupervisor, strategy: :one_for_one, name: ChessEngine.GameSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
