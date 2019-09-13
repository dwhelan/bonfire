defmodule AlphaTest do
  use Test, async: true

  import Alpha
  doctest Alpha

  test "codec" do
    {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z])
    Enum.each(valid, &assert_codec(Alpha, [&1]))
    Enum.each(invalid, &assert_codec_error(Alpha, [&1]))
  end
end
