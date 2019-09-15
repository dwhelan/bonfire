defmodule Decode do
  import Guards

  defmacro defdecode(type, codec \\ __CALLER__.module) do
    [
      create_decode_functions(codec),
      create_decode_module(type)
    ]
  end

  defp create_decode_functions(codec) do
    quote do
      @spec decode(nonempty_list(byte)) :: {nonempty_list(byte), list(byte)} | nil
      def decode([_ | _] = source) do
        decode({[], source})
      end

      @spec decode({list(byte), nonempty_list(byte)}) :: {nonempty_list(byte), list(byte)} | nil
      def decode({dest, source}) do
        case unquote(codec).Decode.apply({Enum.reverse(dest), source}) do
          nil -> nil
          {dest, source} -> {Enum.reverse(dest), source}
        end
      end
    end
  end

  defp create_decode_module({:&, _, _} = predicate) do
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

  defp create_decode_module(byte) when is_octet(byte) do
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
      defmodule Decode do
        @moduledoc false
        import :"Elixir.Decode"

        @spec apply({list(byte), nonempty_list(byte)}) :: {nonempty_list(byte), list(byte)} | nil
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
