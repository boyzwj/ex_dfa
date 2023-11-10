defmodule ExDfaTest do
  use ExUnit.Case
  doctest ExDfa
  ExDfa.build_words(["fuck", "fucking", "毛泽东"])

  test "check unsafe" do
    assert ExDfa.check("1fuck") == {:error, {:unsafe, "fuck"}}
  end

  test "check safe" do
    assert ExDfa.check("1fuc2") == :safe
  end

  test "filter" do
    assert ExDfa.filter("Fucking222毛泽东") == "****ing222***"
  end
end
