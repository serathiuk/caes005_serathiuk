defmodule Board do
  defstruct board: [:e, :e, :e, :e, :e, :e, :e, :e, :e], last_player: :e

  def new, do: %__MODULE__{}

  def execute_command(%__MODULE__{board: board_data}, command = %Command{command: command_value}) do
    position = Command.calculate_board_position(command)
    save_position(board_data, position, command_value)
  end

  def execute_command(_, _), do: {:error, "Invalid command!!!"}

  defp save_position(board_data, position, command_value) when is_list(board_data) and is_number(position) do
    case Enum.at(board_data, position) do
      :e -> %__MODULE__{board: List.replace_at(board_data, position, command_value), last_player: command_value}
      nil -> {:warning, "invalid position"}
      _ -> {:warning, "Position already filled"}
    end
  end

  defp save_position(_, error = {:error, _}, _), do: error
  defp save_position(_, _, _), do: {:error, "Invalid command!!"}

  def check_status(%__MODULE__{last_player: :e}), do: {:error, "Game doesn`t started."}
  def check_status(board = %__MODULE__{board: board_data, last_player: player}), do: {check_status(player, board_data), board}
  def check_status(_), do: {:error, "Invalid board"}

  defp check_status(player, [player, player, player, _, _, _, _, _, _]), do: :win
  defp check_status(player, [_, _, _, player, player, player, _, _, _]), do: :win
  defp check_status(player, [_, _, _, _, _, _, player, player, player]), do: :win
  defp check_status(player, [player, _, _, player, _, _, player, _, _]), do: :win
  defp check_status(player, [_, player, _, _, player, _, _, player, _]), do: :win
  defp check_status(player, [_, _, player, _, _, player, _, _, player]), do: :win
  defp check_status(player, [player, _, _, _, player, _, _, _, player]), do: :win
  defp check_status(player, [_, _, player, _, player, _, player, _, _]), do: :win
  defp check_status(_, list) when is_list(list) do
    total_blank = list
    |> Enum.filter(fn v -> v == :e end)
    |> Enum.count()

    if  total_blank > 0 do
      :continue
    else
      :finished
    end
  end

  def print(%Board{board: board}) do
    lines = board
    |> Enum.map(&convert_characters/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn list -> Enum.join(list, "|") end)
    |> Enum.join("\n-----\n")

    lines <> "\n"
  end

  def convert_characters(:x), do: "X"
  def convert_characters(:o), do: "O"
  def convert_characters(_), do: "#"

end
