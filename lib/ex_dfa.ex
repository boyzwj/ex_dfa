defmodule ExDfa do
  defstruct status: :safe, map: %{}, tmp: ""

  @spec build_file(String.t()) :: :ok
  def build_file(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.to_list()
    |> build_words()
  end

  @spec build_words([String.t()]) :: :ok
  def build_words(words), do: build_words(%{}, words)
  defp build_words(res, words)
  defp build_words(res, []), do: to_data(res)

  defp build_words(res, [word | t]) do
    String.graphemes(word)
    |> Enum.reverse()
    |> scan(:unsafe, res)
    |> build_words(t)
  end

  defp scan([e], c, res) do
    oc = Map.get(res, e)

    cond do
      oc == nil or c == :unsafe ->
        Map.put(res, e, c)

      oc == :unsafe ->
        res

      true ->
        nc = deep_merge(oc, c)
        Map.put(res, e, nc)
    end
  end

  defp scan([e | t], c, res) do
    scan(t, %{e => c}, res)
  end

  defp deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end

  defp deep_resolve(_key, _left, right) do
    right
  end

  defp to_data(dict) do
    dict |> Enum.each(&:persistent_term.put({__MODULE__, elem(&1, 0)}, elem(&1, 1)))
  end

  defp find(token), do: :persistent_term.get({__MODULE__, token}, nil)

  def check(content) do
    try do
      String.graphemes(content) |> do_check(%__MODULE__{})
    catch
      error ->
        {:error, error}
    end
  end

  defp do_check([], %__MODULE__{status: :safe}), do: :safe

  defp do_check([e | t], %__MODULE__{status: :safe} = st) do
    with nil <- find(e) do
      do_check(t, st)
    else
      :unsafe ->
        throw({:unsafe, e})

      data when is_map(data) ->
        do_check(t, %{st | map: data, status: :check, tmp: e})
    end
  end

  defp do_check(_, %__MODULE__{status: :check, map: :unsafe, tmp: tmp}), do: throw({:unsafe, tmp})

  defp do_check([], %__MODULE__{status: :check}), do: :safe

  defp do_check([e | t], %__MODULE__{status: :check, map: map, tmp: tmp} = st) when is_map(map) do
    with nil <- Map.get(map, e) do
      do_check(t, %__MODULE__{})
    else
      map -> do_check(t, %{st | map: map, tmp: tmp <> e})
    end
  end
end
