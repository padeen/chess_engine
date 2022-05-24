defmodule ChessEngineTest do
  use ExUnit.Case
  doctest ChessEngine

  test "greets the world" do
    assert ChessEngine.hello() == :world
  end
end
