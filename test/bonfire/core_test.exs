defmodule CoreTest do
  use Test, async: true

  doctest Core

  describe "rulename" do
    test "first character" do
      {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z])
      Enum.each(valid, &assert_decode(ALPHA, [&1]))
      Enum.each(invalid, &assert_decode_error(ALPHA, [&1]))
    end

    # ALPHA only matches one char we need *ALPHA to support subsequent ALPHAs
    @tag :skip
    test "subsequent characters" do
      #      {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z, ?0..?9, ?-])
      #      Enum.each(valid, &assert_decode(ALPHA, [?a, &1]))
      #      Enum.each(invalid, &assert_decode(ALPHA, [?a, &1], [&1]))
    end
  end

  @tag :skip
  test "OCTET" do
    assert Core.decode("CR", [1]) == {:ok, {[1], ""}}
  end
end
