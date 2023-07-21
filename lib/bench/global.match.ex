  defmodule Global.Match do
    def check(content, words) do
      !(words |> Enum.any?(&String.contains?(content, &1)))
    end

    def filter(content, words) do
      words |> Enum.reduce(content, &String.replace(&2, &1, "*"))
    end
  end
