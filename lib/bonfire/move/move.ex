defmodule Move do
  @typedoc """
  A two element tuple of lists
  """

  @type t :: {list, list}

  @typedoc """
  A mover is used to compose move left and move right operations.

  If the mover is a predicate, it will be passed the first element in the list
  being consumed. If `predicate` returns `true` then processing will continue with the input tuple,
  otherwise processing will continue with `nil`.

  If the mover is a module, it is expected to have submodules named `Left` and `Right`
  with `move_one/1` functions. Those functions will be passed an input tuple and
  processing will continue with the result of the function call.
  """
  @type mover :: module | (t -> boolean)

  @doc """
  A macro that inserts functions for moving multiple items in a list.
  """
  defmacro many do
    quote do
      import Pipes

      @doc """
      Move a range of items from one list to another.

      This function will move as many items from one list to the other list
      as possible, staying within the range. When called from a `Left` module
      it will move items to the left list and when called from a `Right` module
      it will move items to the right list.

      It will wrap all items consumed into a list which will be
      inserted into the target list.

      A negative `from` value in the range will always return nil.
      If the `to` value is less than the `from` value then moving will
      continue until the list being consumed is empty or an error occurs.
      """
      @spec move_many(Move.t(), Range.t(), Move.mover()) :: Move.t()
      def move_many(input, from..to, mover) do
        input
        ~> move_many(from, mover)
        ~> _move_up_to(to - from, mover)
      end

      @doc """
      Move a count of items from one list to another.

      This function will `count` items from one list to the other list.
      When called from a `Left` module it will move items to the left list
      and when called from a `Right` module it will move items to the right list.

      It will wrap all items consumed into a list which will be
      inserted into the target list.
      """
      @spec move_many(Move.t(), integer, Move.mover()) :: Move.t()
      def move_many(input, 0, _) do
        input
      end

      def move_many(input, count, mover) do
        input
        ~> move_first(mover)
        ~> _move_many(count - 1, mover)
      end

      defp _move_up_to(input, 0, _) do
        input
      end

      defp _move_up_to(input, count, mover) do
        input
        ~> move_next(mover)
        ~> _move_up_to(count - 1, mover)
        ~>> return(input)
      end

      defp _move_many(input, 0, _) do
        input
      end

      defp _move_many(input, count, mover) when is_integer(count) do
        input
        ~> move_next(mover)
        ~> _move_many(count - 1, mover)
      end

      defp move_first(input, mover) do
        input
        ~> move_one(mover)
        ~> wrap()
      end

      defp move_next(input, mover) do
        input
        ~> move_one(mover)
        ~> join()
      end

      defp return(_, result) do
        result
      end
    end
  end
end
