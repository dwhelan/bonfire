defmodule Merge do
  @callback apply({[byte], [byte, ...]}) :: {[byte, ...], [byte]} | nil

  defmacro defmerge(do: block) do
    [
      create_merge_functions(__CALLER__.module),
      create_module(block)
    ]
  end

  defmacro defmerge(type, codec) do
    [
      create_merge_functions(codec),
      create_merge_module(type)
    ]
  end

  def merge_one_or_more({_, [byte | _]} = input, predicate) do
    case predicate.(byte) do
      true -> input |> merge_one() |> merge_zero_or_more(predicate)
      false -> nil
    end
  end

  def merge_one_or_more(_, _) do
    nil
  end

  def merge_one({dest, [byte | rest]}) do
    {[byte | dest], rest}
  end

  def merge_one(_) do
    nil
  end

  defp merge_zero_or_more({_, [byte | _]} = input, predicate) do
    case predicate.(byte) do
      true -> input |> merge_one() |> merge_zero_or_more(predicate)
      false -> input
    end
  end

  defp merge_zero_or_more(input, _) do
    input
  end

  defp create_merge_functions(codec) do
    quote bind_quoted: [codec: codec] do
      @spec merge(nonempty_list(byte)) :: {[byte, ...], [byte]} | nil
      def merge([_ | _] = source) do
        merge({[], source})
      end

      @spec merge({[byte], [byte, ...]}) :: {[byte, ...], [byte]} | nil
      def merge({dest, source}) do
        case unquote(codec).Merge.apply({Enum.reverse(dest), source}) do
          nil -> nil
          {dest, source} -> {Enum.reverse(dest), source}
        end
      end
    end
  end

  defp create_merge_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({_, [byte | _]} = input) do
          case unquote(predicate).(byte) do
            false -> nil
            true -> merge_one(input)
          end
        end
      end
    )
  end

  defp create_merge_module(byte) when is_integer(byte) do
    create_module(
      quote do
        def apply({_, [unquote(byte) | _]} = input) do
          merge_one(input)
        end
      end
    )
  end

  defp create_merge_module(byte) when is_list(byte) do
    create_module(
      quote do
        def apply({_, [unquote(byte) | _]} = input) do
          merge_one(input)
        end
      end
    )
  end

  defp create_module(block) do
    # Not using Module.create/3 because it seems simpler to just inject the new module
    # rather than trying to computes its name.
    quote do
      defmodule Merge do
        @moduledoc false
        import :"Elixir.Merge"

        @behaviour :"Elixir.Merge"

        @impl :"Elixir.Merge"
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
