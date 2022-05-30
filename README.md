# ChessEngine

## Projects aim

Backend chess engine in Elixir with OTP for hosting multiple concurrent games. Frontend applications will communicate realtime through the chess interface over Phoenix Channels.


## Running

Add ChessEngine to the same parent folder as ChessInterface. Start application through ChessInterface.

## Communicate with chess engine through repl

`iex -S mix`

`alias ChessEngine.Game`

Start first game

`{:ok, joe} = Game.start_link("Joe")`

`Game.add_player(game, "Hisaishi")`

Check game state

`joe_state = :sys.get_state(joe)`

Start second game concurrently

`{:ok, frank} = Game.start_link("Frank")`

`Game.add_player(game, "Zappa")`

Check game state

`frank_state = :sys.get_state(frank)`
