defmodule BoardTest do
  use ExUnit.Case
  doctest Board

  test "test new board" do
    assert Board.new() == %Board{board: [:e, :e, :e, :e, :e, :e, :e, :e, :e, :e, :e, :e, :e, :e, :e, :e]}
  end

  test "test execute single command for x" do
    assert Board.execute_command(Board.new(), Command.new(:x, 2, 2)) == %Board{board: [:e, :e, :e, :e, :e, :x, :e, :e, :e, :e, :e, :e, :e, :e, :e, :e], last_player: :x}
  end

  test "test execute single command for o" do
    assert Board.execute_command(Board.new(), Command.new(:o, 3, 1)) == %Board{board: [:e, :e, :e, :e, :e, :e, :e, :e, :o, :e, :e, :e, :e, :e, :e, :e], last_player: :o}
  end

  test "test repeteade commands" do
    result = Board.new()
    |> Board.execute_command(Command.new(:x, 1, 1))
    |> Board.execute_command(Command.new(:o, 1, 1))

    assert result == {:warning, "Position already filled"}
  end

  test "test execute multiple commands" do
    assert Board.new()
    |> Board.execute_command(Command.new(:x, 1, 1))
    |> Board.execute_command(Command.new(:o, 1, 2))
    |> Board.execute_command(Command.new(:x, 1, 3))
    |> Board.execute_command(Command.new(:o, 2, 1))
    |> Board.execute_command(Command.new(:x, 2, 2))
    |> Board.execute_command(Command.new(:o, 2, 3))
    |> Board.execute_command(Command.new(:x, 3, 1))
    |> Board.execute_command(Command.new(:o, 3, 2))
    |> Board.execute_command(Command.new(:x, 3, 3)) == %Board{board: [:x, :o, :x, :e, :o, :x, :o, :e, :x, :o, :x, :e, :e, :e, :e, :e], last_player: :x}
  end

  test "test verify is finished when empty" do
    assert Board.new()
    |> Board.check_status() == {:error, "Game doesn`t started."}
  end

  test "test verify is x won" do
    board = Board.new()
    |> Board.execute_command(Command.new(:x, 1, 1))
    |> Board.execute_command(Command.new(:o, 3, 1))
    |> Board.execute_command(Command.new(:x, 2, 2))
    |> Board.execute_command(Command.new(:o, 3, 2))
    |> Board.execute_command(Command.new(:x, 3, 3))
    |> Board.execute_command(Command.new(:o, 1, 3))
    |> Board.execute_command(Command.new(:x, 4, 4))

    assert Board.check_status(board) == {:win, board}
  end

  test "test verify is y won" do
    board = Board.new()
    |> Board.execute_command(Command.new(:x, 1, 1))
    |> Board.execute_command(Command.new(:o, 1, 4))
    |> Board.execute_command(Command.new(:x, 1, 2))
    |> Board.execute_command(Command.new(:o, 2, 3))
    |> Board.execute_command(Command.new(:x, 3, 3))
    |> Board.execute_command(Command.new(:o, 3, 2))
    |> Board.execute_command(Command.new(:x, 2, 1))
    |> Board.execute_command(Command.new(:o, 4, 1))

    assert Board.check_status(board) == {:win, board}
  end

  test "test verify not wont" do
    board = Board.new()
    |> Board.execute_command(Command.new(:x, 1, 3))
    |> Board.execute_command(Command.new(:o, 1, 1))
    |> Board.execute_command(Command.new(:x, 2, 3))
    |> Board.execute_command(Command.new(:o, 2, 2))

    assert Board.check_status(board) == {:continue, board}
  end

  test "test print empty" do
    print = """
     #|#|#|#
     -------
     #|#|#|#
     -------
     #|#|#|#
     -------
     #|#|#|#
     """

    assert Board.print(Board.new) == print
  end

  test "test print complete board" do
    print = """
     X|O|X|O
     -------
     X|O|X|O
     -------
     X|O|X|O
     -------
     O|X|O|X
     """

    board = Board.new()
    |> Board.execute_command(Command.new(:x, 1, 1))
    |> Board.execute_command(Command.new(:o, 1, 2))
    |> Board.execute_command(Command.new(:x, 1, 3))
    |> Board.execute_command(Command.new(:o, 1, 4))
    |> Board.execute_command(Command.new(:x, 2, 1))
    |> Board.execute_command(Command.new(:o, 2, 2))
    |> Board.execute_command(Command.new(:x, 2, 3))
    |> Board.execute_command(Command.new(:o, 2, 4))
    |> Board.execute_command(Command.new(:x, 3, 1))
    |> Board.execute_command(Command.new(:o, 3, 2))
    |> Board.execute_command(Command.new(:x, 3, 3))
    |> Board.execute_command(Command.new(:o, 3, 4))
    |> Board.execute_command(Command.new(:x, 4, 2))
    |> Board.execute_command(Command.new(:o, 4, 1))
    |> Board.execute_command(Command.new(:x, 4, 4))
    |> Board.execute_command(Command.new(:o, 4, 3))

    assert Board.print(board) == print
  end

  test "test partial board" do
    print = """
     X|#|#|#
     -------
     #|X|#|#
     -------
     O|O|X|#
     -------
     #|#|#|#
     """

    board = Board.new()
    |> Board.execute_command(Command.new(:x, 1, 1))
    |> Board.execute_command(Command.new(:o, 3, 1))
    |> Board.execute_command(Command.new(:x, 2, 2))
    |> Board.execute_command(Command.new(:o, 3, 2))
    |> Board.execute_command(Command.new(:x, 3, 3))

    assert Board.print(board) == print
  end

end
