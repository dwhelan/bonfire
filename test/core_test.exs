defmodule CoreTest do
  use Test, async: true
  import Core
  import Guards

  doctest Core

  describe "rulename" do
    test "first character" do
      {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z])
      Enum.each(valid, &assert_decode(Alpha, [&1]))
      Enum.each(invalid, &assert_decode_error(Alpha, [&1]))
    end

    test "subsequent characters" do
      {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z, ?0..?9, ?-])
      #      Enum.each(valid, &assert_decode(Alpha, [?a, &1]))
      #      Enum.each(invalid, &assert_decode(Alpha, [?a, &1], [&1]))
    end
  end

  @tag :skip
  test "OCTET" do
    assert Core.decode("CR", [1]) == {:ok, {[1], ""}}
  end
end
