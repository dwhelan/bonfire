defmodule Codec do
  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
    end
  end

  defmacro defcodec1(predicate) do
    codec = __CALLER__.module

    quote do
      def decode({dest, [_ | _] = source}) when is_list(dest) do
        case unquote(codec).Decode.apply({Enum.reverse(dest), source}) do
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
        def apply({dest, [char | rest]}) when is_list(dest) do
          case unquote(predicate).(char) do
            true -> {[char | dest], rest}
            false -> nil
          end
        end
      end

      def encode({[_ | _] = source, dest}) do
        case unquote(codec).Encode.apply({source, Enum.reverse(dest)}) do
          nil -> nil
          {source, dest} -> {source, Enum.reverse(dest)}
        end
      end

      def encode(source) when is_list(source) do
        encode({source, []})
      end

      def encode(_) do
        nil
      end

      defmodule Encode do
        def apply({[char | rest], dest} = input) do
          case unquote(predicate).(char) do
            true -> {rest, [char|dest]}
            false -> nil
          end
        end
      end
    end
  end
end
