defmodule Zip do
  @callback apply({[byte, ...], [byte]}) :: {[byte], [byte, ...]} | nil

  defmacro defzip(type, zipper \\ __CALLER__.module) do
    [
      create_zip_functions(zipper),
      create_zip_module(type)
    ]
  end

  def zip_one_or_more({[byte | _], _} = input, predicate) do
    case predicate.(byte) do
      true -> input |> zip_one() |> more(predicate)
      false -> nil
    end
  end

  def zip_one_or_more(_, _) do
    nil
  end

  def zip_one({[byte | rest], dest}) do
    {rest, [byte | dest]}
  end

  def zip_one(_) do
    nil
  end

  defp more({[byte | _], _} = input, predicate) do
    case predicate.(byte) do
      true -> input |> zip_one() |> more(predicate)
      false -> input
    end
  end

  defp more(input, predicate) do
    input
  end

  defp create_zip_functions(zipper) do
    quote do
      @spec zip(nonempty_list(byte)) :: {[byte], [byte, ...]} | nil
      def zip([_ | _] = source) do
        zip({source, []})
      end

      @spec zip({[byte, ...], [byte]}) :: {[byte], [byte, ...]} | nil
      def zip({source, dest}) do
        case unquote(zipper).Zip.apply({source, Enum.reverse(dest)}) do
          nil -> nil
          {source, dest} -> {source, Enum.reverse(dest)}
        end
      end
    end
  end

  defp create_zip_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({[byte | rest], dest} = input) do
          case unquote(predicate).(byte) do
            false -> nil
            true -> zip_one(input)
          end
        end
      end
    )
  end

  defp create_zip_module(byte) do
    create_module(
      quote do
        def apply({[unquote(byte) | rest] = source, dest} = input) do
          zip_one(input)
        end
      end
    )
  end

  defp create_module(block) do
    # Not using Module.create/3 because it seems simpler to just inject the new module
    # rather than trying to computes its name.
    quote do
      defmodule Zip do
        @moduledoc false
        import :"Elixir.Zip"

        @behaviour :"Elixir.Zip"

        @impl :"Elixir.Zip"
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end
end
