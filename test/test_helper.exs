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

  defmacro test_zipper(zipper, valid_values) do
    quote do
      test "zipper with #{inspect(unquote(valid_values))}}" do
        {valid, invalid} = build_test_charlist(unquote(valid_values))
        Enum.each(valid, fn value -> assert_zipper(unquote(zipper), [value]) end)
        Enum.each(invalid, fn value -> assert_zipper_error(unquote(zipper), [value]) end)
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

  def assert_zipper(zipper, source, rest \\ '') do
    assert_unzip(zipper, source ++ rest, rest)
    assert_zip(zipper, source ++rest, rest)
  end

  def assert_zipper_error(zipper, source) do
    assert_unzip_error(zipper, source)
    assert_zip_error(zipper, source)
  end

  def assert_unzip(zipper, source, rest \\ []) do
    {bytes, rest} = Enum.split(source, length(source) - length(rest))
    assert {^bytes, ^rest} = zipper.unzip(source)
  end

  def assert_unzip_error(zipper, source) do
    assert zipper.unzip(source) == nil
  end

  def assert_zip(zipper, source, rest \\ []) do
    {value, rest} = Enum.split(source, length(source) - length(rest))
    assert {^rest, ^value} = zipper.zip(source)
  end

  def assert_zip_error(zipper, source) do
    assert zipper.zip(source) == nil
  end
end
