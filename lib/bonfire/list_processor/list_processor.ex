defmodule ListProcessor do
  @moduledoc """
  Support for building a bi-directional data pipeline for two lists.

  Either list can be deeply nested.

  For speed purposes all list operations are done at the head of either list.
  """

  @typedoc """
  A tuple with two lists: `{left, right}`.
  """
  @type t :: {list, list}

  @typedoc """
  The result from a move operation.
  """
  @type result :: t | ListProcessor.Error.t()

  @doc """
  Move an item from one list to another.
  """
  @callback move_one(t) :: result

  @doc """
  Move an item from one list to another.
  """
  @callback move_one(t, processor) :: result

  @doc """
  Moves zero or more items from one list to the other list as a list.

  The number of items to list_processor can be either an integer or a range.
  A `processor` is passed and is used to determin≤e whether processing should continue.
  """
  @callback move_to_list(t, Range.t() | integer, processor) :: result

  @typedoc """
  A predicate or module used to compose list processor operations.

  If the processor is a predicate, it will be called with the first element in the list
  being consumed. If the processor returns `true` then processing will continue with the input tuple,
  otherwise processing will continue with `nil`.

  If the processor is a module, it is expected to have submodules named `MoveLeft` and `Right`
  that implement `ListProcessor` behaviour. Those functions will be called with an input tuple and
  processing will continue with the result of that function call.
  """
  @type processor :: module | (t -> boolean)

  direction = Right

  block =
    quote do
      import ListProcessor.Pipes

      @doc """
      Move one item from the left list to the right.

      The head item from the left list will be removed and will become the head item in the right list.

      A `nil` will be returned if the left list is empty.
      """
      @spec move_one(ListProcessor.t()) :: ListProcessor.result()

      def move_one(input) do
        input
        ~> to_source_dest()
        ~> _move_one()
        ~> from_source_dest()
      end

      def _move_one({[], _}) do
        nil
      end

      def _move_one({[value | source], dest}) do
        {source, [value | dest]}
      end

      defp _move_one({[], _}, _) do
        nil
      end

      def move_one(input, processor) do
        input
        ~> to_source_dest()
        ~> _move_one(processor)
        ~> from_source_dest()
      end

      defp _move_one({[value | _], _} = input, predicate) when is_function(predicate, 1) do
        case predicate.(value) do
          true -> _move_one(input)
          false -> nil
        end
      end

      defp _move_one(input, processor) do
        Module.concat(processor, unquote(direction)).move_one(input)
      end

      @doc """
      Move items from the #{@source} into the #{@target} as a list.

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
      @spec move_to_list(ListProcessor.t(), Range.t() | integer, ListProcessor.processor()) ::
              ListProcessor.result()
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
        ~> insert_list()
        ~> _move_to_list(count, processor)
      end

      defp _move_up_to(input, 0, _) do
        input
      end

      defp _move_up_to(input, count, processor) do
        input
        ~> move_one(processor)
        ~> move_dest_value_into_list()
        ~> _move_up_to(count - 1, processor)
        ~>> return(input)
      end

      defp _move_to_list(input, 0, _) do
        input
      end

      defp _move_to_list(input, count, processor) when is_integer(count) do
        input
        ~> move_one(processor)
        ~> move_dest_value_into_list()
        ~> _move_to_list(count - 1, processor)
      end

      defp return(_, result) do
        result
      end

      defp insert_list({source, dest}) do
        {source, [[] | dest]}
      end

      defp move_dest_value_into_list({source, [value, list | dest]}) do
        {source, [[value | list] | dest]}
      end
    end

  source =
    quote do
      unquote(block)

      defp to_source_dest(input) do
        input
      end

      defp from_source_dest(input) do
        input
      end
    end

  __MODULE__
  |> Module.concat(Right)
  |> Module.create(source, Macro.Env.location(__ENV__))

  left =
    quote do
      unquote(block)

      defp to_source_dest({dest, source}) do
        {source, dest}
      end

      defp from_source_dest({source, dest}) do
        {dest, source}
      end
    end

  __MODULE__
  |> Module.concat(Left)
  |> Module.create(left, Macro.Env.location(__ENV__))
end
