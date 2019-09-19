ExUnit.start(exclude: :skip, async: true)

defmodule Test do
  import Guards
  import ExUnit.Assertions

  defmacro __using__(_) do
    quote do
      use ExUnit.Case
      import Test
      import Guards
    end
  end

  defmacro test_guard(guard, valid_values) do
    quote do
      test "#{unquote(guard)} with #{inspect(unquote(valid_values))}}" do
        {valid, invalid} = build_test_charlist(unquote(valid_values))
        Enum.each(valid, fn value -> assert Guards.unquote(guard)(value) end)
        Enum.each(invalid, fn value -> refute Guards.unquote(guard)(value) end)
      end
    end
  end

  defmacro test_codec(codec, valid_values) do
    quote do
      test "codec with #{inspect(unquote(valid_values))}}" do
        {valid, invalid} = build_test_charlist(unquote(valid_values))
        Enum.each(valid, fn value -> assert_codec(unquote(codec), [value]) end)
        Enum.each(invalid, fn value -> assert_codec_error(unquote(codec), [value]) end)
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

  def assert_codec(codec, source, rest \\ '') do
    assert_unzip(codec, source ++ rest, rest)
    assert_zip(codec, source ++rest, rest)
  end

  def assert_codec_error(codec, source) do
    assert_unzip_error(codec, source)
    assert_zip_error(codec, source)
  end

  def assert_unzip(codec, source, rest \\ []) do
    {bytes, rest} = Enum.split(source, length(source) - length(rest))
    assert {^bytes, ^rest} = codec.unzip(source)
  end

  def assert_unzip_error(codec, source) do
    assert codec.unzip(source) == nil
  end

  def assert_zip(codec, source, rest \\ []) do
    {value, rest} = Enum.split(source, length(source) - length(rest))
    assert {^rest, ^value} = codec.zip(source)
  end

  def assert_zip_error(codec, source) do
    assert codec.zip(source) == nil
  end
end
