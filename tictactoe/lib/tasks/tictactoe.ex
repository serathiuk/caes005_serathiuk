defmodule Mix.Tasks.Tictactoe do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    Tictactoe.start_game()

  end


  def convert_list(list) do
    {list1, list2} =  Enum.split(list, trunc(length(list) / 2))
    Enum.zip(list, list2 ++ list1)
  end
end
