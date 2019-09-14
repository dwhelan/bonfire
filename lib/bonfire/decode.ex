defmodule Decode do
  defmacro __using__(opts \\ []) do
    quote do
      import Decode, unquote(opts)
    end
  end

  def defdecode1(codec, predicate) do
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

      defmodule Decode do
        @moduledoc false

        @spec apply({list(char), nonempty_list(char)}) :: {nonempty_list(char), list(char)} | nil
        def apply({dest, [char | rest]}) when is_list(dest) do
          case unquote(predicate).(char) do
            true -> {[char | dest], rest}
            false -> nil
          end
        end
      end
    end
  end
end
