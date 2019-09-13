defmodule Action do
  defmacro defaction(name) do
    quote do
      source = """
            defaction decode, is_digit, shift_left
      """

      code = Code.string_to_quoted!(source)

      IO.inspect(block: source, code: inspect(code))
    end
  end
end
