defmodule DigitTest do
  use Test, async: true

  import Digit
  doctest Digit

  test "codec" do
    {valid, invalid} = build_test_charlist([?0..?9])
    Enum.each(valid, &assert_codec(Digit, [&1]))
    Enum.each(invalid, &assert_codec_error(Digit, [&1]))
  end
end
