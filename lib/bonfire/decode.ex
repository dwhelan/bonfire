defmodule Decode do
  defmacro defdecode(codec, predicate) do
    [base(codec), create_decode_module(predicate)]
  end

  defp base(codec) do
    quote do
      @spec decode(nonempty_list(char)) :: {nonempty_list(char), list(char)} | nil
      def decode([_ | _] = source) do
        decode({[], source})
      end

      @spec decode({list(char), nonempty_list(char)}) :: {nonempty_list(char), list(char)} | nil
      def decode({dest, source}) do
        case unquote(codec).Decode.apply({Enum.reverse(dest), source}) do
          nil -> nil
          {dest, source} -> {Enum.reverse(dest), source}
        end
      end
    end
  end

  defp create_decode_module(predicate) do
    quote do
      defmodule Decode do
        @moduledoc false
        import :"Elixir.Decode"

        @spec apply({list(char), nonempty_list(char)}) :: {nonempty_list(char), list(char)} | nil
        def apply({dest, [char | rest]} = input) do
          case unquote(predicate).(char) do
            true -> {[char | dest], rest}
            false -> nil
          end
        end
      end
    end
  end

  defmacro decode_char char, f do
    quote do
      def apply({dest, [unquote(char) | rest] = source} = input) do
        unquote(f).({[unquote(char) | dest], rest})
      end

      def apply(_) do
        nil
      end
    end
  end
end
