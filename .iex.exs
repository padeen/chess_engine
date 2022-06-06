alias ChessEngine.{Board, Game, GameSupervisor, Move, Position}

board = Board.start_new()

{:ok, d1} = Position.new("d", 1)
{:ok, d2} = Position.new("d", 2)
{:ok, d7} = Position.new("d", 7)
{:ok, d8} = Position.new("d", 8)
