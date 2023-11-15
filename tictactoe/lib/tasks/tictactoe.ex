defmodule Mix.Tasks.Tictactoe do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    Tictactoe.start_game()
  end
end
