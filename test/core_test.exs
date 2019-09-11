defmodule CoreTest do
  use ExUnit.Case, async: true

  import Core
  import Guards
  doctest Core

  describe "rulename" do
    test "first character" do
      {valid, invalid} = build_charlist([?A..?Z, ?a..?z])
      Enum.each(valid, &assert_rulename([&1]))
      Enum.each(invalid, &assert(rulename([&1]) == nil))
    end

    test "subsequent characters" do
      {valid, invalid} = build_charlist([?A..?Z, ?a..?z, ?0..?9, ?-])
      Enum.each(valid, &assert_rulename([?a, &1]))
      Enum.each(invalid, &assert_rulename([?a, &1], [&1]))
    end

    test "invalid input" do
      assert(rulename(:not_a_list) == nil)
      assert(rulename(["abc"]) == nil)
    end
  end

  defp build_charlist(values) do
    valid =
      Enum.map(
        values,
        fn
          char when is_octet(char) -> [char]
          range -> Enum.to_list(range)
        end
      )
      |> List.flatten()

    invalid = Enum.to_list(0..255) -- valid
    {valid, invalid}
  end

  defp assert_rulename(input) do
    assert rulename(input) == {%{type: :rulename, value: input, code: nil, comments: nil}, []}
  end

  defp assert_rulename(input, rest) do
    {value, _} = Enum.split(input, length(input) - length(rest))
    assert rulename(input) == {%{type: :rulename, value: value, code: nil, comments: nil}, rest}
  end

  @tag :skip
  test "OCTET" do
    assert Core.decode("CR", [1]) == {:ok, {[1], ""}}
  end
end
