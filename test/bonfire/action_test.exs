defmodule Element do
  defmodule Action do
    def apply(arg) do
      {:ok, arg}
    end
  end
end

defmodule ActionTest do
  use ExUnit.Case, async: true

  doctest Action

  test "apply" do
    assert Action.apply({Element, Action}, :foo) == {:ok, :foo}
  end
end
