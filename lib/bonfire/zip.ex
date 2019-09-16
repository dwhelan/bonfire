defmodule Zip do
  defmacro defzip(predicate, codec) do
    [
      create_zip_functions(codec),
      create_zip_module(predicate)
    ]
  end

  defp create_zip_functions(codec) do
    quote do
      @spec zip(nonempty_list(byte)) :: {list(byte), nonempty_list(byte)} | nil
      def zip([_ | _] = source) do
        zip({source, []})
      end

      @spec zip({nonempty_list(byte), list(byte)}) :: {list(byte), nonempty_list(byte)} | nil
      def zip({source, dest}) do
        case unquote(codec).Zip.apply({source, Enum.reverse(dest)}) do
          nil -> nil
          {source, dest} -> {source, Enum.reverse(dest)}
        end
      end
    end
  end

  defp create_zip_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({[byte | rest] = source, dest}) do
          case unquote(predicate).(byte) do
            true -> {rest, [byte | dest]}
            false -> nil
          end
        end
      end
    )
  end

  defp create_module(block) do
    quote do
      defmodule Zip do
        @moduledoc false
        import :"Elixir.Zip"

        @spec apply({nonempty_list(byte), list(byte)}) :: {list(byte), nonempty_list(byte)} | nil
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
