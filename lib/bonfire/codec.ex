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
      def decode({dest, [_ | _] = source}) do
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

defmodule Encode do
  def defencode1(codec, predicate) do
    quote do
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
        @moduledoc false

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

defmodule Codec do
  @type t :: {list(char), list(char)}
  require Decode

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
    end
  end

  defmacro defcodec1(predicate) do
    decode = Decode.defdecode1(__CALLER__.module, predicate)

    encode = Encode.defencode1(__CALLER__.module, predicate)
    [decode, encode]
  end
end
