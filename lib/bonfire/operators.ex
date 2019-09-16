defmodule Operators do
  defmacro lhs ~> rhs do
    quote do
      case unquote(lhs) do
        nil -> unquote(lhs)
        _ -> unquote(Macro.pipe(lhs, rhs, 0))
      end
    end
  end

  defmacro lhs ~>> rhs do
    quote do
      case unquote(lhs) do
        nil -> unquote(Macro.pipe(lhs, rhs, 0))
        _ -> unquote(lhs)
      end
    end
  end
end

