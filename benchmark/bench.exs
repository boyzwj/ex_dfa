dirty_words =
  File.stream!("./priv/dirty_words.txt")
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Enum.to_list()
ExDfa.build_words(dirty_words)
content = "fufu今天是个好日子,法轮功,我操你妈"


Benchee.run(%{
  "GLOBAL_MATCH_FILTER" => fn ->
    Global.Match.filter(content, dirty_words)
  end,
  "DFA_FILTER" => fn ->
    ExDfa.filter(content)
  end
})
Benchee.run(%{
  "GLOBAL_MATCH_CHECK" => fn ->
    Global.Match.check(content, dirty_words)
  end,
  "DFA_CHECK" => fn ->
    ExDfa.check(content)
  end
})
