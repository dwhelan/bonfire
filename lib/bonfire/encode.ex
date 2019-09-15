defmodule Encode do
  defmacro defencode(predicate, codec) do
    [
      create_encode_functions(codec),
      create_encode_module(predicate)
    ]
  end

  defp create_encode_functions(codec) do
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

  defp create_encode_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({[char | rest] = source, dest}) do
          case unquote(predicate).(char) do
            true -> {rest, [char | dest]}
            false -> nil
          end
        end
      end
    )
  end

  defp create_module(block) do
    quote do
      defmodule Encode do
        @moduledoc false
        import :"Elixir.Encode"

        @spec apply({nonempty_list(char), list(char)}) :: {list(char), nonempty_list(char)} | nil
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
