defmodule Decode do
  import Guards

  defmacro defdecode(predicate, codec \\ __CALLER__.module) do
    [
      create_decode_functions(codec),
      create_decode_module(predicate)
    ]
  end

  defp create_decode_functions(codec) do
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

  defp create_decode_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({dest, [char | rest]} = input) do
          case unquote(predicate).(char) do
            true -> {[char | dest], rest}
            false -> nil
          end
        end
      end
    )
  end

  defp create_decode_module(char) when is_octet(char) do
    IO.inspect char: char
    create_module(
      quote do
        def apply({dest, [unquote(char) | rest] = source} = input) do
          {[unquote(char) | dest], rest}
        end
      end
    )
  end

  defp create_module(block) do
    quote do
      defmodule Decode do
        @moduledoc false
        import :"Elixir.Decode"

        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
