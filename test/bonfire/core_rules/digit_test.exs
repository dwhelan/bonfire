defmodule DigitTest do
  use Test, async: true

  import DIGIT
  doctest DIGIT

  test "codec" do
    {valid, invalid} = build_test_charlist([?0..?9])
    Enum.each(valid, &assert_codec(DIGIT, [&1]))
    Enum.each(invalid, &assert_codec_error(DIGIT, [&1]))
  end
end
