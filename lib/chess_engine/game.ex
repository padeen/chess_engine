defmodule ChessEngine.Game do
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient

  alias ChessEngine.{Board, Gamestate, Move, Position}

  @colors [:white, :black]
  @player [:player1, :player2]
  @timeout 1000 * 60 * 60

  def start_link(name) when is_binary(name),
    do: GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  def via_tuple(name), do: {:via, Registry, {Registry.Game, name}}

  def add_player(game, name) when is_binary(name),
    do: GenServer.call(game, {:add_player, name})

  def select_colors(game, player1_color, player2_color)
      when player1_color in @colors and player2_color in @colors,
      do: GenServer.call(game, {:select_colors, player1_color, player2_color})

  def move_piece(game, player_color, current_file, current_rank, target_file, target_rank),
    do:
      GenServer.call(
        game,
        {:move_piece, player_color, current_file, current_rank, target_file, target_rank}
      )

  def init(name) do
    player1 = %{name: name, color: nil}
    player2 = %{name: nil, color: nil}

    {:ok,
     %{player1: player1, player2: player2, board: Board.start_new(), gamestate: Gamestate.new()},
     @timeout}
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

  def handle_call(
        {:move_piece, player_color, current_file, current_rank, target_file, target_rank},
        _from,
        state_data
      ) do
    with {:ok, _gamestate} <- Gamestate.check(state_data.gamestate, {:move_piece, player_color}),
         {:ok, current_position} <- Position.new(current_file, current_rank),
         {:ok, target_position} <- Position.new(target_file, target_rank) do
      case Board.move_piece(state_data.board, current_position, target_position) do
        %Board{} = board ->
          {:reply, board, state_data}
          # :captured_opponents_piece -> {:ok, :captured_piece}
          # :no_capture -> {:ok, :no_capture}
          # :movement_not_in_moveset -> :movement_not_in_moveset
      end
    else
      :error -> {:reply, :error, state_data}
    end
  end

  def handle_info(:timeout, state_data) do
    {:stop, {:shutdown, :timeout}, state_data}
  end

  defp update_player2_name(state_data, name), do: put_in(state_data.player2.name, name)

  defp update_gamestate(state_data, gamestate), do: %{state_data | gamestate: gamestate}

  defp update_player_colors(state_data, player1_color, player2_color) do
    state_data
    |> put_in([:player1, :color], player1_color)
    |> put_in([:player2, :color], player2_color)
  end

  defp reply_success(state_data, reply), do: {:reply, reply, state_data, @timeout}
end
