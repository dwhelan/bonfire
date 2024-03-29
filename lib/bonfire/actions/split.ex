defmodule Split do
  @moduledoc """
  Functions and macros for splitting.
  """
  import DualStack.{Right, Pipes}

  @callback move_one(any) :: {[byte], [byte, ...]} | nil

  defmacro defsplit(type, codec \\ __CALLER__.module) do
    [
      create_split_functions(codec),
      create_split_module(type)
    ]
  end

  defp create_split_functions(codec) do
    quote do
      @spec split(nonempty_list(byte)) :: {[byte], [byte, ...]} | DualStack.Error.t()
      def split([_ | _] = left) do
        split({left, []})
      end

      @spec split({[byte, ...], [byte]}) :: {[byte], [byte, ...]} | DualStack.Error.t()
      def split(input) do
        input
        ~> reverse_dest()
        ~> unquote(codec).Right.move_one()
        ~> reverse_dest()
      end

      defp reverse_dest({source, dest}) do
        {source, Enum.reverse(dest)}
      end
    end
  end

  defp create_split_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def move_one({[byte | rest], dest} = input) do
          DualStack.Right.move_one(input, unquote(predicate))
        end
      end
    )
  end

  defp create_split_module(byte) do
    create_module(
      quote do
        def move_one({[unquote(byte) | rest] = source, dest} = input) do
          DualStack.Right.move_one(input)
        end
      end
    )
  end

  defp create_module(block) do
    # Not using Module.create/3 because it seems simpler to just inject the new module
    # rather than trying to computes its name.
    quote do
      defmodule Right do
        @moduledoc false
        import Split

        @behaviour Elixir.Split

        @impl Split
        unquote(block)

        def move_one(_) do
          nil
        end
      end
    end
  end
end
