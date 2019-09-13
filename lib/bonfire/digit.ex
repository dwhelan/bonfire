defmodule Rule do
  defmacro __using__(opts \\ []) do
    quote do
      import Rule, unquote(opts)
    end
  end

  defmacro defrule do
    quote do
      def decode([_ | _] = list) do
        decode({list, ''})
      end
    end
  end

  defmacro defrule(do: block) do
    quote do
      unquote(block)

      def decode([_ | _] = chars) do
        decode({[], chars})
      end

      def decode(_) do
        nil
      end

      def encode([_ | _] = values) do
        encode({values, []})
      end

      def encode([char | rest]) when is_digit(char) do
        {[char], rest}
      end
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
end

defmodule Digit do
  @moduledoc """

  ## Examples

      iex> decode '123'
      {'1', '23'}

      iex> decode {'', '123'}
      {'1', '23'}

      iex> decode {'1', '23'}
      {'12', '3'}

      iex> decode {'12', '3'}
      {'123', ''}

      iex> decode {'123', ''}
      nil

      iex> decode :non_digit
      nil

      iex> encode '123'
      {'23', '1'}

      iex> encode {'123', ''}
      {'23', '1'}

      iex> encode {'23', '1'}
      {'3', '12'}

      iex> encode {'3', '12'}
      {'', '123'}

      iex> encode :non_digit
      nil
  """
  import Guards
  use Rule

  defdecode do
    def apply({_, [char | _]} = input) when is_digit(char) do
      shift_left(input)
    end
  end

  defmodule Encode do
    def apply([_ | _] = values) do
      apply({values, []})
    end

    def apply({[value | _], _} = input) when is_digit(value) do
      shift_right(input)
    end

    def apply(_) do
      nil
    end
  end

  defrule do
    def decode(input) do
      Decode.apply(input)
    end

    def encode(input) do
      Encode.apply(input)
    end
  end
end
