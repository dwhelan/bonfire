defmodule Encode do
  defp defencode(codec) do
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
    end
  end

  defp defencode1Module(predicate) do
    quote do
      defmodule Encode do
        @moduledoc false

        @spec apply({nonempty_list(char), list(char)}) :: {list(char), nonempty_list(char)} | nil
        def apply({[char | rest], dest}) do
          case unquote(predicate).(char) do
            true -> {rest, [char | dest]}
            false -> nil
          end
        end
      end
    end
  end

  def defencode1(codec, predicate) do
    [
      defencode(codec),
      defencode1Module(predicate)
    ]
  end
end
