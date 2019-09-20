defmodule Move.MoveMany do
  defmacro move_many do
    quote do
      import Pipes

      def move_many(input, 0, _) do
        input
      end

      def move_many(input, from..to, mover) do
        input
        ~> move_many(from, mover)
        ~> _move_up_to(to - from, mover)
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

defmodule Move.Right do
  @moduledoc """
  Functions for shifting elements from a left list to a right list.
  """
  alias Move.MoveMany
  require MoveMany

  MoveMany.move_many

  def move_one({[], _}) do
    nil
  end

  def move_one({[value | left], right}) do
    {left, [value | right]}
  end

  def move_one({[], _}, _) do
    nil
  end

  def move_one({[value | _], _} = input, predicate) when is_function(predicate, 1) do
    case predicate.(value) do
      true -> move_one(input)
      false -> nil
    end
  end

  def move_one(input, mover) do
    Module.concat(mover, Right).move_one(input)
  end

  def wrap({_, []}) do
    nil
  end

  def wrap({left, [value | right]}) do
    {left, [[value] | right]}
  end

  def join({_, []}) do
    nil
  end

  def join({left, [value, values | right]}) do
    {left, [[value | values] | right]}
  end

  def reverse({left, right}) do
    {left, Enum.reverse(right)}
  end
end
