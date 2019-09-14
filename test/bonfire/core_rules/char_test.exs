defmodule CHARTest do
  use Test, async: true

  import CHAR
  doctest CHAR

  test "codec" do
    {valid, invalid} = build_test_charlist(1..127)
    Enum.each(valid, &assert_codec(CHAR, [&1]))
    Enum.each(invalid, &assert_codec_error(CHAR, [&1]))
  end
end
