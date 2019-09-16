defmodule Unzip do
  defmacro defunzip(type, zipper \\ __CALLER__.module) do
    [
      create_unzip_functions(zipper),
      create_unzip_module(type)
    ]
  end

  defp create_unzip_functions(zipper) do
    quote bind_quoted: [zipper: zipper] do
      @spec unzip(nonempty_list(byte)) :: {nonempty_list(byte), list(byte)} | nil
      def unzip([_ | _] = source) do
        unzip({[], source})
      end

      @spec unzip({list(byte), nonempty_list(byte)}) :: {nonempty_list(byte), list(byte)} | nil
      def unzip({dest, source}) do
        case unquote(zipper).Unzip.apply({Enum.reverse(dest), source}) do
          nil -> nil
          {dest, source} -> {Enum.reverse(dest), source}
        end
      end
    end
  end

  defp create_unzip_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({dest, [byte | rest]} = input) do
          case unquote(predicate).(byte) do
            true -> {[byte | dest], rest}
            false -> nil
          end
        end
      end
    )
  end

  defp create_unzip_module(byte) do
    create_module(
      quote do
        def apply({dest, [unquote(byte) | rest] = source} = input) do
          {[unquote(byte) | dest], rest}
        end
      end
    )
  end

  defp create_module(block) do
    quote do
      defmodule Unzip do
        @moduledoc false
        import :"Elixir.Unzip"

        @spec apply({list(byte), nonempty_list(byte)}) :: {nonempty_list(byte), list(byte)} | nil
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
