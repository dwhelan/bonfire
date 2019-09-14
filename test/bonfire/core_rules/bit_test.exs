defmodule BitTest do
  use Test, async: true

  import Bit
  doctest Bit

  test "codec" do
    {valid, invalid} = build_test_charlist([0, 1])
    Enum.each(valid, &assert_codec(Bit, [&1]))
    Enum.each(invalid, &assert_codec_error(Bit, [&1]))
  end
end
