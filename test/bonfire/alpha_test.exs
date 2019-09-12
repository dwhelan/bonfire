defmodule AlphaTest do
  use Test, async: true

  import Alpha
  doctest Alpha

  test "decode" do
    {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z])
    Enum.each(valid, &assert_decode(Alpha, [&1]))
    Enum.each(invalid, &assert_decode_error(Alpha, [&1]))
  end

  test "encode" do
    {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z])
    Enum.each(valid, &assert_encode(Alpha, [&1]))
    Enum.each(invalid, &assert_encode_error(Alpha, [&1]))
  end
end
