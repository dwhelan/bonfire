defmodule ListProcessor do
  @moduledoc """
  Support for building a bi-directional data pipeline for two lists.

  The `move_one` function moves an item from one list to the other.
  `The `move_to_list` functions moves zero or more items from one
  list and moves them as a list to the other list. This enables
  deeply nested lists to be on either side.

  Moves from the left to the right

  """

  @typedoc """
  A two element tuple of lists.

  Represents the
  """

  @type t :: {list, list}

  @typedoc """
  A mover is used to compose move left and move right operations.

  If the mover is a predicate, it will be passed the first element in the list
  being consumed. If `predicate` returns `true` then processing will continue with the input tuple,
  otherwise processing will continue with `nil`.

  If the mover is a module, it is expected to have submodules named `Left` and `MoveRight`
  with `move_one/1` functions. Those functions will be called with an input tuple and
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
        ListProcessor.Left ->
          @target "left"
          @source "right"

        ListProcessor.MoveRight ->
          @target "right"
          @source "left"
      end

      @doc """
      ListProcessor many items from the #{@source} list to the #{@target}.

      If `count` is an `t:Integer.t/0` then `count` items will be moved
      or `nil` will be returned.

      If `count` is a `t:Range.t/0` then as many items as possible will be
      moved, staying within the range.
      If `count.first` is negative, `nil` will be returned.
      If `count.last` is less than `count.first` then items will
      be moved until the #{@source} list is empty or an error occurs.

      The `mover` will be called with each item from the #{@source} list and the
      result will be used to insert into the #{@target} list.

      All items consumed will be combined into a list which will be
      inserted as a single item into the #{@target} list.

      ## Examples

      """
      @spec move_to_list(ListProcessor.t(), Range.t() | integer, ListProcessor.mover()) :: ListProcessor.t()
      def move_to_list(input, first..last, mover) do
        input
        ~> move_to_list(first, mover)
        ~> _move_up_to(last - first, mover)
      end

      def move_to_list(input, 0, _) do
        input
      end

      def move_to_list(input, count, mover) do
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
