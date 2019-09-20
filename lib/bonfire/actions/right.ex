defmodule Right do
  @moduledoc """
  Functions and macros for splitting.
  """
  import Pipes
  import Lists.Right

  @callback apply(any) :: {[byte], [byte, ...]} | nil
  @callback move_one(any) :: {[byte], [byte, ...]} | nil

  defmacro defsplit(type, codec \\ __CALLER__.module) do
    [
      create_split_functions(codec),
      create_split_module(type)
    ]
  end

  defp create_split_functions(codec) do
    quote do
      alias Lists.Right
      @spec split(nonempty_list(byte)) :: {[byte], [byte, ...]} | nil
      def split([_ | _] = left) do
        split({left, []})
      end

      @spec split({[byte, ...], [byte]}) :: {[byte], [byte, ...]} | nil
      def split(input) do
        input
        ~> Right.reverse()
        ~> unquote(codec).Right.move_one()
        ~> Right.reverse()
      end
    end
  end

  defp create_split_module({:&, _, _} = predicate) do
    create_module(
      quote do
        @impl :"Elixir.Right"
        def apply({[byte | rest], dest} = input) do
          Lists.Right.move_one(input, unquote(predicate))
        end

        @impl :"Elixir.Right"
        def move_one({[byte | rest], dest} = input) do
          Lists.Right.move_one(input, unquote(predicate))
        end
      end
    )
  end

  defp create_split_module(byte) do
    create_module(
      quote do
        @impl :"Elixir.Right"
        def apply({[unquote(byte) | rest] = source, dest} = input) do
          Lists.Right.move_one(input)
        end

        @impl :"Elixir.Right"
        def move_one({[unquote(byte) | rest] = source, dest} = input) do
          Lists.Right.move_one(input)
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
        import :"Elixir.Right"

        @behaviour :"Elixir.Right"
        unquote(block)

        def apply(_) do
          nil
        end

        def move_one(_) do
          nil
        end
      end
    end
  end

  def move_zero_or_more(input, mover) do
    input
    ~> move_one_or_more(mover)
    ~>> return(input)
  end

  def move_one_or_more(input, mover) do
    input
    ~> move_one(mover)
    ~> wrap()
    ~> _move_zero_or_more(mover)
  end

  defp _move_zero_or_more(input, mover) do
    input
    ~> move_one(mover)
    ~> join()
    ~> _move_zero_or_more(mover)
    ~>> return(input)
  end

  defp return(_, result) do
    result
  end
end
