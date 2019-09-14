defmodule BitTest do
  use Test, async: true

  import BIT
  doctest BIT

  test "codec" do
    {valid, invalid} = build_test_charlist([0, 1])
    Enum.each(valid, &assert_codec(BIT, [&1]))
    Enum.each(invalid, &assert_codec_error(BIT, [&1]))
  end
end
