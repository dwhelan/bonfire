ExUnit.start(exclude: :skip, async: true)

defmodule Test do
  import Guards
  import ExUnit.Assertions

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

  def assert_decode(codec, input, rest \\ []) do
    {chars, rest} = Enum.split(input, length(input) - length(rest))
    assert {^chars, ^rest} = codec.decode(input)
  end

  def assert_decode_error(codec, input) do
    assert codec.decode(input) == nil
  end

  def assert_encode(codec, input, rest \\ []) do
    {chars, rest} = Enum.split(input, length(input) - length(rest))
    assert {^chars, ^rest} = codec.encode(input)
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
