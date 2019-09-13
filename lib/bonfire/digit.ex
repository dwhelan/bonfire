defmodule Foo do
  defmacro defdecode1(f, p) do
    quote do
      defmodule Decode do
        def apply([_ | _] = chars) do
          apply({[], chars})
        end

        def apply(input) do
          case input do
            {_, [char | _]} ->
              case unquote(p).(char) do
                true -> unquote(f).(input)
                false -> nil
              end
              _ -> nil
          end
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
  use Rule
  import Foo

  defdecode1(fn input -> shift_left(input) end, &is_digit/1)

  defcodec

  defencode do
    def apply({[value | _], _} = input) when is_digit(value) do
      shift_right(input)
    end
  end
end
