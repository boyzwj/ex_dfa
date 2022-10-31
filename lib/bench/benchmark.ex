defmodule ExDfa.Benchmark do
  @path :code.priv_dir(:ex_dfa)

  defmodule Global.Match do
    def check(content, words) do
      !(words |> Enum.any?(&String.contains?(content, &1)))
    end

    def filter(content, words) do
      words |> Enum.reduce(content, &String.replace(&2, &1, "*"))
    end
  end

  def bench_check() do
    dirty_words =
      File.stream!("#{@path}/dirty_words.txt")
      |> Stream.map(&String.replace(&1, "\n", ""))
      |> Enum.to_list()

    ExDfa.build_words(dirty_words)

    content = "fufu今天是个好日子,法轮功,我操你妈"

    Benchee.run(%{
      "GLOBAL_MATCH" => fn ->
        Global.Match.check(content, dirty_words)
      end,
      "DFA" => fn ->
        ExDfa.check(content)
      end
    })
  end

  def bench_filter() do
    dirty_words =
      File.stream!("#{@path}/dirty_words.txt")
      |> Stream.map(&String.replace(&1, "\n", ""))
      |> Enum.to_list()

    ExDfa.build_words(dirty_words)

    content = "fufu今天是个好日子,法轮功,我操你妈"

    Benchee.run(%{
      "GLOBAL_MATCH" => fn ->
        Global.Match.filter(content, dirty_words)
      end,
      "DFA" => fn ->
        ExDfa.filter(content)
      end
    })
  end
end
