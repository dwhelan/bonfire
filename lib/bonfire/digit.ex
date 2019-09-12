defmodule Rule do
  defmacro defrule do
    quote do
      def decode([_ | _] = list) do
        decode({list, ''})
      end
    end
  end

  defmacro defrule(do: block) do
    quote do
      def decode([_ | _] = list) do
        decode({list, ''})
      end

      unquote(block)

      def decode(_) do
        nil
      end

      def encode([char | rest]) when is_digit(char) do
        {[char], rest}
      end

    end
  end

  defmacro __using__(opts \\ []) do
    quote do
      import Rule, unquote(opts)
    end
  end

  def shift_left({[char | chars], rest}) do
      {[char], chars ++ rest}
  end

  defmacro defaction name do
    quote do

    end
  end
end

defmodule Digit do
  @moduledoc """

  ## Examples

      iex> decode '123'
      {'1', '23'}

      iex> decode {'123', ''}
      {'1', '23'}

      iex> decode {'123', 'abc'}
      {'1', '23abc'}

      iex> decode :non_digit
      nil

      iex> encode '123'
      {'1', '23'}

      iex> encode {'123', ''}
      {'1', '23'}

      iex> encode {'123', 'abc'}
      {'1', '23abc'}

      iex> encode :non_digit
      nil
  """
  import Guards
  use Rule

  defmodule Decode do
    def apply({[char | _ ], _} = input) when is_digit(char) do
      shift_left input
    end
  end

  defmodule Encode do
    def apply({[char | _ ], _} = input) when is_digit(char) do
      shift_left input
    end
  end

  defrule do
    def decode({[char | rest], right}) when is_digit(char) do
      Decode.apply({[char], rest ++ right})
    end

    def encode({[char | rest], right}) when is_digit(char) do
      Encode.apply({[char], rest ++ right})
    end
  end


  def encode(_) do
    nil
  end
end
