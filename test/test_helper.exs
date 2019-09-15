ExUnit.start(exclude: :skip, async: true)

defmodule Test do
  import Guards
  import ExUnit.Assertions

  defmacro test_codec(codec, valid_values) do
    quote do
      test "codec with #{inspect(unquote(valid_values))}}" do
        {valid, invalid} = build_test_charlist(unquote(valid_values))
        Enum.each(valid, &assert_codec(unquote(codec), [&1]))
        Enum.each(invalid, &assert_codec_error(unquote(codec), [&1]))
      end
    end
  end

  def build_test_charlist(values) do
    valid =
      Enum.map(
        values,
        fn
          char when is_octet(char) -> [char]
          range -> Enum.to_list(range)
        end
      )
      |> List.flatten()

    invalid = Enum.to_list(0..255) -- valid
    {valid, invalid}
  end

  def assert_codec(codec, input, rest \\ []) do
    assert_decode(codec, input, rest)
    assert_encode(codec, input, rest)
  end

  def assert_codec_error(codec, input) do
    assert_decode_error(codec, input)
    assert_encode_error(codec, input)
  end

  def assert_decode(codec, input, rest \\ []) do
    {bytes, rest} = Enum.split(input, length(input) - length(rest))
    assert {^bytes, ^rest} = codec.decode(input)
  end

  def assert_decode_error(codec, input) do
    assert codec.decode(input) == nil
  end

  def assert_encode(codec, input, rest \\ []) do
    {value, rest} = Enum.split(input, length(input) - length(rest))
    assert {^rest, ^value} = codec.encode(input)
  end

  def assert_encode_error(codec, input) do
    assert codec.encode(input) == nil
  end

  defmacro __using__(opts \\ []) do
    quote do
      use ExUnit.Case, unquote(opts)
      import Test
    end
  end
end
