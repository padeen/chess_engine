defmodule ChessEngine.Game do
  use GenServer

  alias ChessEngine.{Board, Gamestate, Move}

  @colors [:white, :black]
  @player [:player1, :player2]
  @timeout_one_hour 3_600_000

  def start_link(name) when is_binary(name),
    do: GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  def via_tuple(name), do: {:via, Registry, {Registry.Game, name}}

  def add_player(game, name) when is_binary(name),
    do: GenServer.call(game, {:add_player, name})

  def select_colors(game, player1_color, player2_color)
      when player1_color in @colors and player2_color in @colors,
      do: GenServer.call(game, {:select_colors, player1_color, player2_color})

  def init(name) do
    player1 = %{name: name, color: nil}
    player2 = %{name: nil, color: nil}

    {:ok,
     %{player1: player1, player2: player2, board: Board.start_new(), gamestate: Gamestate.new()}}
  end

  def handle_call({:add_player, name}, _from, state_data) do
    with {:ok, gamestate} = Gamestate.check(state_data.gamestate, :add_player) do
      state_data
      |> update_player2_name(name)
      |> update_gamestate(gamestate)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state_data}
    end
  end

  def handle_call({:select_colors, player1_color, player2_color}, _from, state_data) do
    with {:ok, gamestate} = Gamestate.check(state_data.gamestate, :select_colors) do
      state_data
      |> update_player_colors(player1_color, player2_color)
      |> update_gamestate(gamestate)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state_data}
    end
  end

  defp update_player2_name(state_data, name), do: put_in(state_data.player2.name, name)

  defp update_gamestate(state_data, gamestate), do: %{state_data | gamestate: gamestate}

  defp update_player_colors(state_data, player1_color, player2_color) do
    state_data
    |> put_in([:player1, :color], player1_color)
    |> put_in([:player2, :color], player2_color)
  end

  defp reply_success(state_data, reply), do: {:reply, reply, state_data}
end
