defmodule Encode do
  def defencode1(codec, predicate) do
    quote do
      @spec encode(nonempty_list(char)) :: {list(char), nonempty_list(char)} | nil
      def encode([_ | _] = source) do
        encode({source, []})
      end

      @spec encode({nonempty_list(char), list(char)}) :: {list(char), nonempty_list(char)} | nil
      def encode({source, dest}) do
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
