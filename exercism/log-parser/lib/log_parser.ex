defmodule LogParser do
  def valid_line?(line), do: Regex.match?(~r/^\[DEBUG|INFO|WARNING|ERROR\]\s\w+/, line)
  def split_line(line), do: Regex.split(~r{<[~*=-]*>}, line)
  def remove_artifacts(line), do: Regex.replace(~r/end\-of\-line[\d]+/i, line, "")

  def tag_with_user_name(line) do
    case Regex.scan(~r/User\s+(\S+)/u, line) do
      [[_, user]] -> "[USER] #{user} #{line}"
      _ -> line
    end
  end
end
