defmodule Decode do
  def defdecode(codec, predicate, opts \\ [])

  def defdecode(codec, predicate, []) do
    [base(codec), decode_one(predicate)]
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

  defp decode_one(predicate) do
    quote do
      defmodule Decode do
        @moduledoc false

        @spec apply({list(char), nonempty_list(char)}) :: {nonempty_list(char), list(char)} | nil
        def apply({dest, [char | rest]}) do
          case unquote(predicate).(char) do
            true -> {[char | dest], rest}
            false -> nil
          end
        end
      end
    end
  end
end
