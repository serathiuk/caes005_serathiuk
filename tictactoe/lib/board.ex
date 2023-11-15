defmodule Board do
  defstruct board: [:e, :e, :e, :e, :e, :e, :e, :e, :e], last_player: :e

  def new, do: %__MODULE__{}

  def execute_command(%__MODULE__{board: board_data}, command = %Command{command: command_value}) do
    position = Command.calculate_board_position(command)
    save_position(board_data, position, command_value)
  end

  def execute_command(_, _), do: {:error, "Invalid command"}

  defp save_position(board_data, position, command_value) when is_list(board_data) and is_number(position) do
    case Enum.at(board_data, position) do
      :e -> %__MODULE__{board: List.replace_at(board_data, position, command_value), last_player: command_value}
      nil -> {:error, "invalid position"}
      _ -> {:error, "position already filled"}
    end
  end

  defp save_position(_, error = {:error, _}, _), do: error
  defp save_position(_, _, _), do: {:error, "Invalid command"}

  def is_finished(%__MODULE__{last_player: :e}), do: {:error, "Game doesn`t started."}
  def is_finished(board = %__MODULE__{board: board_data, last_player: player}) do
    case is_finished(player, board_data) do
      true -> {:finished, board}
      false -> {:continue, board}
    end
  end
  def is_finished(_), do: {:error, "Invalid board"}

  defp is_finished(player, [player, player, player, _, _, _, _, _, _]), do: true
  defp is_finished(player, [_, _, _, player, player, player, _, _, _]), do: true
  defp is_finished(player, [_, _, _, _, _, _, player, player, player]), do: true
  defp is_finished(player, [player, _, _, player, _, _, player, _, _]), do: true
  defp is_finished(player, [_, player, _, _, player, _, _, player, _]), do: true
  defp is_finished(player, [_, _, player, _, _, player, _, _, player]), do: true
  defp is_finished(player, [player, _, _, _, player, _, _, _, player]), do: true
  defp is_finished(player, [_, _, player, _, player, _, player, _, _]), do: true
  defp is_finished(_, _), do: false

  def print(%Board{board: board}) do
    lines = board
    |> Enum.map(&convert_characters/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn list -> Enum.join(list, "|") end)
    |> Enum.join("\n-----\n")

    lines <> "\n"
  end

  defp convert_characters(:x), do: "X"
  defp convert_characters(:o), do: "O"
  defp convert_characters(_), do: "#"

end
