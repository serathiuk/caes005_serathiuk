defmodule Tictactoe do
  @moduledoc """
  Documentation for `Tictactoe`.
  """

  def start_game() do
    IO.puts("------------------------------")
    IO.puts("| Serathiuk`s TicTacToe 4 Row |")
    IO.puts("------------------------------")

    board = Board.new()
    ask_position(board, :x)
  end

  defp ask_position(board = %Board{}, player) do
    IO.puts(Board.print(board))

    player_str = Board.convert_characters(player)
    IO.puts("--------")

    IO.puts("Player "<>  player_str)
    IO.puts("--------")

    line = get_number("Line:")
    column = get_number("Column:")

    IO.puts("--------")

    result = Board.execute_command(board, Command.new(player, line, column))
    case result do
      board = %Board{} -> execute_check_status(board, player)
      {:warning, message} ->
        IO.puts(message)
        ask_position(board, player)
      {:error, message} -> IO.puts(message)
    end

  end

  defp execute_check_status(board = %Board{}, player) do
    player_str = Board.convert_characters(player)

    case Board.check_status(board) do
      {:finished, _} -> IO.puts("Game finished without winner.")
      {:win, _} ->
        IO.puts("Player "<>player_str<>" won.")
        IO.puts(Board.print(board))
      {:continue, _} -> ask_position(board, if player == :x do :o else :x end)
      {:error, message} -> IO.puts(message)
    end
  end

  defp get_number(message) do
    value = IO.gets(message)
    |> String.trim()
    |> Integer.parse()

    case value do
      {number, _} when number in [1, 2, 3, 4] -> number
      _ -> get_number(message)
    end
  end
end
