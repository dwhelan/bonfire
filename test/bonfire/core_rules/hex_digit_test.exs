defmodule HEXDIGITTest do
  use Test, async: true

  import HEXDIGIT
  doctest HEXDIGIT

  test "codec" do
    {valid, invalid} = build_test_charlist([?0..?9])
    Enum.each(valid, &assert_codec(HEXDIGIT, [&1]))
    Enum.each(invalid, &assert_codec_error(HEXDIGIT, [&1]))
  end
end
