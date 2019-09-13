defmodule Codec do
  @type t :: {list(char), list(char)}

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
    end
  end

  defmacro defcodec1(predicate) do
    codec = __CALLER__.module

    quote do
      @spec decode(nonempty_list(char)) :: {nonempty_list(char), list(char)} | nil
      def decode([_ | _] = source) do
        decode({[], source})
      end

      @spec decode({list(char), nonempty_list(char)}) :: {nonempty_list(char), list(char)} | nil
      def decode({dest, [_ | _] = source}) do
        case unquote(codec).Decode.apply({Enum.reverse(dest), source}) do
          nil -> nil
          {dest, source} -> {Enum.reverse(dest), source}
        end
      end

      defmodule Decode do
        @spec apply({list(char), nonempty_list(char)}) :: {nonempty_list(char), list(char)} | nil
        def apply({dest, [char | rest]}) when is_list(dest) do
          case unquote(predicate).(char) do
            true -> {[char | dest], rest}
            false -> nil
          end
        end
      end

      @spec encode(nonempty_list(char)) :: {list(char), nonempty_list(char)} | nil
      def encode([_ | _] = source) do
        encode({source, []})
      end

      @spec encode({nonempty_list(char), list(char)}) :: {list(char), nonempty_list(char)} | nil
      def encode({[_ | _] = source, dest}) do
        case unquote(codec).Encode.apply({source, Enum.reverse(dest)}) do
          nil -> nil
          {source, dest} -> {source, Enum.reverse(dest)}
        end
      end

      defmodule Encode do
        @spec apply({nonempty_list(char), list(char)}) :: {list(char), nonempty_list(char)} | nil
        def apply({[char | rest], dest} = input) do
          case unquote(predicate).(char) do
            true -> {rest, [char | dest]}
            false -> nil
          end
        end
      end
    end
  end
end
