defmodule CommandTest do
  use ExUnit.Case
  doctest Command

  @invalid_command_response {:error, "Invalid command."}

  test "create a valid x" do
    assert Command.new(:x, 1, 2) == %Command{command: :x, line: 1, column: 2}
  end

  test "create a valid o" do
    assert Command.new(:o, 2, 3) == %Command{command: :o, line: 2, column: 3}
  end

  test "calculate the board position 1, 1" do
    assert Command.calculate_board_position(%Command{command: :o, line: 1, column: 1}) == 0
  end

  test "calculate the board position 1, 2" do
    assert Command.calculate_board_position(%Command{command: :o, line: 1, column: 2}) == 1
  end

  test "calculate the board position 1, 3" do
    assert Command.calculate_board_position(%Command{command: :o, line: 1, column: 3}) == 2
  end

  test "calculate the board position 2, 1" do
    assert Command.calculate_board_position(%Command{command: :o, line: 2, column: 1}) == 3
  end

  test "calculate the board position 2, 2" do
    assert Command.calculate_board_position(%Command{command: :o, line: 2, column: 2}) == 4
  end

  test "calculate the board position 2, 3" do
    assert Command.calculate_board_position(%Command{command: :o, line: 2, column: 3}) == 5
  end

  test "calculate the board position 3, 1" do
    assert Command.calculate_board_position(%Command{command: :o, line: 3, column: 1}) == 6
  end

  test "calculate the board position 3, 2" do
    assert Command.calculate_board_position(%Command{command: :o, line: 3, column: 2}) == 7
  end

  test "calculate the board position 3, 3" do
    assert Command.calculate_board_position(%Command{command: :o, line: 3, column: 3}) == 8
  end

  test "invalid board position input" do
    assert Command.calculate_board_position(2) == @invalid_command_response
    assert Command.calculate_board_position(nil) == @invalid_command_response
    assert Command.calculate_board_position("1,2") == @invalid_command_response
    assert Command.calculate_board_position([1, 2]) == @invalid_command_response
  end

  test "invalid command" do
    assert Command.new(:e, 2, 3) == @invalid_command_response
    assert Command.new(:test, 2, 3) == @invalid_command_response
    assert Command.new(1, 2, 3) == @invalid_command_response
    assert Command.new(nil, 2, 3) == @invalid_command_response
    assert Command.new("x", 2, 3) == @invalid_command_response
    assert Command.new("o", 2, 3) == @invalid_command_response
  end

  test "invalid line" do
    assert Command.new(:o, -1, 1) == @invalid_command_response
    assert Command.new(:o, 4, 2) == @invalid_command_response
    assert Command.new(:x, "1", 3) == @invalid_command_response
    assert Command.new(:x, "3", 3) == @invalid_command_response
    assert Command.new(:x, nil, 3) == @invalid_command_response
  end

  test "invalid column" do
    assert Command.new(:o, 1, -1) == @invalid_command_response
    assert Command.new(:o, 2, 4) == @invalid_command_response
    assert Command.new(:x, 3, "1") == @invalid_command_response
    assert Command.new(:x, 1,"3") == @invalid_command_response
    assert Command.new(:x, 2, nil) == @invalid_command_response
  end

end
