defmodule Zip do
  @callback apply({[byte, ...], [byte]}) :: {[byte], [byte, ...]} | nil

  defmacro defzip(type, zipper_or_predicate \\ __CALLER__.module) do
    [
      create_zip_functions(zipper_or_predicate),
      create_zip_module(type)
    ]
  end

  def zip_one_or_more(input, zipper) when is_atom(zipper) do
    input |> zip_zero_or_more(zipper)
    case zipper.zip(input) do
      nil -> nil
      result -> result |> zip_zero_or_more(zipper)
    end
  end

  def zip_one_or_more({[byte | _], _} = input, predicate) do
    case predicate.(byte) do
      true -> input |> zip_one() |> zip_zero_or_more(predicate)
      false -> nil
    end
  end

  def zip_zero_or_more({[byte | _], _} = input, zipper) when is_atom(zipper) do
    case zipper.zip(input) do
      nil -> input
      result -> input |> zip_one() |> zip_zero_or_more(zipper)
    end
  end

  def zip_zero_or_more({[byte | _], _} = input, predicate) do
    case predicate.(byte) do
      true -> input |> zip_one() |> zip_zero_or_more(predicate)
      false -> input
    end
  end

  def zip_zero_or_more(input, _) do
    input
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
