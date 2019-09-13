defmodule Rule do
  defmacro __using__(opts \\ []) do
    quote do
      import Rule, unquote(opts)
    end
  end

  def shift_left({values, [char | rest]}) do
    {values ++ [char], rest}
  end

  def shift_right({[value | values], rest}) do
    {values, rest ++ [value]}
  end

  defmacro defaction(name) do
    quote do
      source = """
            defaction decode, is_digit, shift_left
      """

      code = Code.string_to_quoted!(source)

      IO.inspect(block: source, code: inspect(code))
    end
  end

  defmacro defdecode(do: block) do
    quote do
      defmodule Decode do
        def apply([_ | _] = chars) do
          apply({[], chars})
        end

        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end

  defmacro defencode(do: block) do
    quote do
      defmodule Encode do
        def apply([_ | _] = values) do
          apply({values, []})
        end

        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
