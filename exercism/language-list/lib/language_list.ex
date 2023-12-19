defmodule LanguageList do
  def new(), do: []

  def add(list, language), do: [language | list]

  def remove([_ | new_list]), do: new_list

  def first([first | _]), do: first

  def count(list), do: length(list)

  def functional_list?(list), do: functional_list?(list, 0)

  defp functional_list?([], count), do: count > 0
  defp functional_list?(["Elixir" | tail], count), do: functional_list?(tail, count + 1)
  defp functional_list?([_ | tail], count), do: functional_list?(tail, count)
end
