defmodule ListProcessor do

  @moduledoc """
  Support for building a bi-directional data pipeline for two lists.

  Either list can be deeply nested.

  For speed purposes all list operations are done at the head of either list.
  """
  @doc """
  Move an item from one list to the other.
  """
  @callback move_one(t) :: t | nil

  @doc """
  Moves zero or more items from one list to the other list as a list.

  The number of items to list_processor can be either an integer or a range.
  A `processor` is passed and is used to determin≤e whether processing should continue.
  """
  @callback move_to_list(t, Range.t() | integer, processor) :: t | nil

  @typedoc """
  A tuple with two lists: `{left, right}`.
  """
  @type t :: {list, list}

  @typedoc """
  A predicate or module used to compose list processor operations.

  If the processor is a predicate, it will be called with the first element in the list
  being consumed. If the processor returns `true` then processing will continue with the input tuple,
  otherwise processing will continue with `nil`.

  If the processor is a module, it is expected to have submodules named `MoveLeft` and `MoveRight`
  that implement `ListProcessor` behaviour. Those functions will be called with an input tuple and
  processing will continue with the result of that function call.
  """
  @type processor :: module | (t -> boolean)


  @doc """
  A macro that inserts functions for moving multiple items in a list.
  """
  defmacro many do
    quote do
      import ListProcessor.Pipes

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

      The `processor` will be called with each item from the #{@source} list and the
      result will be used to insert into the #{@target} list.

      All items consumed will be combined into a list which will be
      inserted as a single item into the #{@target} list.

      ## Examples

      """
      @spec move_to_list(ListProcessor.t(), Range.t() | integer, ListProcessor.processor()) :: ListProcessor.t()
      def move_to_list(input, first..last, processor) do
        input
        ~> move_to_list(first, processor)
        ~> _move_up_to(last - first, processor)
      end

      def move_to_list(input, 0, _) do
        input
      end

      def move_to_list(input, count, processor) do
        input
        ~> move_first(processor)
        ~> _move_many(count - 1, processor)
      end

      defp _move_up_to(input, 0, _) do
        input
      end

      defp _move_up_to(input, count, processor) do
        input
        ~> move_next(processor)
        ~> _move_up_to(count - 1, processor)
        ~>> return(input)
      end

      defp _move_many(input, 0, _) do
        input
      end

      defp _move_many(input, count, processor) when is_integer(count) do
        input
        ~> move_next(processor)
        ~> _move_many(count - 1, processor)
      end

      defp move_first(input, processor) do
        input
        ~> move_one(processor)
        ~> wrap()
      end

      defp move_next(input, processor) do
        input
        ~> move_one(processor)
        ~> join()
      end

      defp return(_, result) do
        result
      end
    end
  end
end
