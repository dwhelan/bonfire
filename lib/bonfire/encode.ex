defmodule Encode do
  def defencode(codec, predicate, opts \\ [])

  def defencode(codec, predicate, []) do
    [base(codec), encode_one(predicate)]
  end

  defp base(codec) do
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

  defp encode_one(predicate) do
    quote do
      defmodule Encode do
        @moduledoc false

        @spec apply({nonempty_list(char), list(char)}) :: {list(char), nonempty_list(char)} | nil
        def apply({[char | rest] = source, dest}) do
          case unquote(predicate).(char) do
            true -> {rest, [char | dest]}
            false -> nil
          end
        end
      end
    end
  end
end
