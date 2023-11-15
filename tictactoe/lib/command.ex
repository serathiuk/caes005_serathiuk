defmodule Command do
  @commands [:x, :o]

  defstruct command: :e, line: 0, column: 0

  @spec new(any(), number(), number()) ::
          {:error, <<_::128>>} | %Command{command: :o | :x, line: number(), column: number()}

  def new(command, line, column)
    when command in @commands and
         is_number(line) and line >= 1 and line <= 3 and
         is_number(column) and column >= 1 and column <= 3 do
    %__MODULE__{command: command, line: line, column: column}
  end

  def new(_, _, _), do: {:error, "Invalid command."}

  def calculate_board_position(%Command{line: line, column: column}) do
    (column - 1) + (3 * (line - 1))
  end

  def calculate_board_position(_), do: {:error, "Invalid command."}

  def commands, do: @commands

end
