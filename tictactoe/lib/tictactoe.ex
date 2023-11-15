defmodule Tictactoe do
  @moduledoc """
  Documentation for `Tictactoe`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Tictactoe.hello()
      :world

  """
  def start_game() do
    IO.puts("-------------------------")
    IO.puts("| Serathiuk`s TicTacToe |")
    IO.puts("-------------------------")

    board = Board.new()

    IO.puts(Board.print(board))

    IO.get
  end

  def get_number(message) do

  end
end
