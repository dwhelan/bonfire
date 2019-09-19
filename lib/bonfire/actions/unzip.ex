defmodule Unsplit do
  @callback apply({[byte], [byte, ...]}) :: {[byte, ...], [byte]} | nil

  defmacro defunsplit(do: block) do
    [
      create_unsplit_functions(__CALLER__.module),
      create_module(block)
    ]
  end

  defmacro defunsplit(type, codec) do
    [
      create_unsplit_functions(codec),
      create_unsplit_module(type)
    ]
  end

  def unsplit_one_or_more({_, [byte | _]} = input, predicate) do
    case predicate.(byte) do
      true -> input |> unsplit_one() |> unsplit_zero_or_more(predicate)
      false -> nil
    end
  end

  def unsplit_one_or_more(_, _) do
    nil
  end

  def unsplit_one({dest, [byte | rest]}) do
    {[byte | dest], rest}
  end

  def unsplit_one(_) do
    nil
  end

  defp unsplit_zero_or_more({_, [byte | _]} = input, predicate) do
    case predicate.(byte) do
      true -> input |> unsplit_one() |> unsplit_zero_or_more(predicate)
      false -> input
    end
  end

  defp unsplit_zero_or_more(input, _) do
    input
  end

  defp create_unsplit_functions(codec) do
    quote bind_quoted: [codec: codec] do
      @spec unsplit(nonempty_list(byte)) :: {[byte, ...], [byte]} | nil
      def unsplit([_ | _] = source) do
        unsplit({[], source})
      end

      @spec unsplit({[byte], [byte, ...]}) :: {[byte, ...], [byte]} | nil
      def unsplit({dest, source}) do
        case unquote(codec).Unsplit.apply({Enum.reverse(dest), source}) do
          nil -> nil
          {dest, source} -> {Enum.reverse(dest), source}
        end
      end
    end
  end

  defp create_unsplit_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({_, [byte | _]} = input) do
          case unquote(predicate).(byte) do
            false -> nil
            true -> unsplit_one(input)
          end
        end
      end
    )
  end

  defp create_unsplit_module(byte) when is_integer(byte) do
    create_module(
      quote do
        def apply({_, [unquote(byte) | _]} = input) do
          unsplit_one(input)
        end
      end
    )
  end

  defp create_unsplit_module(byte) when is_list(byte) do
    create_module(
      quote do
        def apply({_, [unquote(byte) | _]} = input) do
          unsplit_one(input)
        end
      end
    )
  end

  defp create_module(block) do
    # Not using Module.create/3 because it seems simpler to just inject the new module
    # rather than trying to computes its name.
    quote do
      defmodule Unsplit do
        @moduledoc false
        import :"Elixir.Unsplit"

        @behaviour :"Elixir.Unsplit"

        @impl :"Elixir.Unsplit"
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
