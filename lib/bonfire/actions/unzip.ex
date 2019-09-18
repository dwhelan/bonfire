defmodule Unzip do
  @callback apply({[byte], [byte, ...]}) :: {[byte, ...], [byte]} | nil

  defmacro defunzip(do: block) do
    [
      create_unzip_functions(__CALLER__.module),
      create_module(block)
    ]
  end

  defmacro defunzip(type, zipper) do
    [
      create_unzip_functions(zipper),
      create_unzip_module(type)
    ]
  end

  def one_or_more({dest, [byte | rest]}, predicate) do
    case predicate.(byte) do
      true -> more({[byte | dest], rest}, predicate)
      false -> nil
    end
  end

  def one_or_more(_, _) do
    nil
  end

  defp more({dest, [byte | rest]} = input, predicate) do
    case predicate.(byte) do
      true -> more({[byte | dest], rest}, predicate)
      false -> input
    end
  end

  defp more(input, predicate) do
    input
  end


  defp create_unzip_functions(zipper) do
    quote bind_quoted: [zipper: zipper] do
      @spec unzip(nonempty_list(byte)) :: {[byte, ...], [byte]} | nil
      def unzip([_ | _] = source) do
        unzip({[], source})
      end

      @spec unzip({[byte], [byte, ...]}) :: {[byte, ...], [byte]} | nil
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
            false -> nil
            true -> {[byte | dest], rest}
          end
        end
      end
    )
  end

  defp create_unzip_module(byte) when is_integer(byte) do
    create_module(
      quote do
        def apply({dest, [unquote(byte) | rest] = source} = input) do
          {[unquote(byte) | dest], rest}
        end
      end
    )
  end

  defp create_unzip_module(byte) when is_list(byte) do
    create_module(
      quote do
        def apply({dest, [unquote(byte) | rest] = source} = input) do
          {[unquote(byte) | dest], rest}
        end
      end
    )
  end

  defp create_module(block) do
    # Not using Module.create/3 because it seems simpler to just inject the new module
    # rather than trying to computes its name.
    quote do
      defmodule Unzip do
        @moduledoc false
        import :"Elixir.Unzip"

        @behaviour :"Elixir.Unzip"

        @impl :"Elixir.Unzip"
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
