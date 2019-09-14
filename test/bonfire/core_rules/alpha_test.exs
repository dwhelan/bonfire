defmodule ALPHATest do
  use Test, async: true

  import ALPHA
  doctest ALPHA

  test "codec" do
    {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z])
    Enum.each(valid, &assert_codec(ALPHA, [&1]))
    Enum.each(invalid, &assert_codec_error(ALPHA, [&1]))
  end
end
