defmodule Codec do
  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
    end
  end

  defmacro defcodec1(predicate) do
    quote do
      def decode({dest, [_ | _] = source}) when is_list(dest) do
        case unquote(__CALLER__.module).Decode.apply({Enum.reverse(dest), source}) do
          nil -> nil
          {dest, source} -> {Enum.reverse(dest), source}
        end
      end

      def decode(source) when is_list(source) do
        decode({[], source})
      end

      def decode(_) do
        nil
      end

      defmodule Decode do
        def apply({dest, [char | rest]}) do
          case unquote(predicate).(char) do
            true -> {[char | dest], rest}
            false -> nil
          end
        end
      end

      def encode(input) do
        unquote(__CALLER__.module).Encode.apply(input)
      end

      defmodule Encode do
        def apply([_ | _] = values) do
          apply({values, []})
        end

        def apply({[value | _], _} = input) do
          case unquote(predicate).(value) do
            true -> shift_right(input)
            false -> nil
          end
        end

        def apply(_) do
          nil
        end
      end
    end
  end

  def shift_right({[value | values], rest}) do
    {values, rest ++ [value]}
  end
end
