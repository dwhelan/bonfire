ExUnit.start(exclude: :skip, async: true)

defmodule Test do
  import Guards
  import ExUnit.Assertions

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

  def assert_zipper(zipper, input, rest \\ '') do
    assert_unzip(zipper, input ++ rest, rest)
    assert_zip(zipper, input ++rest, rest)
  end

  def assert_zipper_error(zipper, input) do
    assert_unzip_error(zipper, input)
    assert_zip_error(zipper, input)
  end

  def assert_unzip(zipper, input, rest \\ []) do
    {bytes, rest} = Enum.split(input, length(input) - length(rest))
    assert {^bytes, ^rest} = zipper.unzip(input)
  end

  def assert_unzip_error(zipper, input) do
    assert zipper.unzip(input) == nil
  end

  def assert_zip(zipper, input, rest \\ []) do
    {value, rest} = Enum.split(input, length(input) - length(rest))
    assert {^rest, ^value} = zipper.zip(input)
  end

  def assert_zip_error(zipper, input) do
    assert zipper.zip(input) == nil
  end

  defmacro __using__(opts \\ []) do
    quote do
      use ExUnit.Case, unquote(opts)
      import Test
      import Guards
    end
  end
end
