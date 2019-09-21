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

      case __MODULE__ do
        Move.Left ->
          @target "left"
          @source "right"

        Move.Right ->
          @target "right"
          @source "left"
      end

      @doc """
      Move many items from the #{@source} list to the #{@target}.

      If `count` is an `t:Integer.t/0` then `count` items will be moved.

      If `count` is a `t:Range.t/0` then as many items as possible will be
      moved, staying within the range.
      If `count.first` is negative, `nil` will be returned.
      If `count.last` is less than `count.first` then items will
      be moved until the #{@source} list is empty or an error occurs.

      This function will wrap all items consumed into a list which will be
      inserted into the #{@target} list.
      """
      @spec move_many(Move.t(), Range.t() | integer, Move.mover()) :: Move.t()
      def move_many(input, first..last, mover) do
        input
        ~> move_many(first, mover)
        ~> _move_up_to(last - first, mover)
      end

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
