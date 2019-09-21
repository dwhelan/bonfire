defmodule ListProcessor.Error do
  @moduledoc """
  Represents an error in the list processing.

  Currently an error is simply represented as `nil`. This makes
  error handling simple.
  """
  @type t :: nil

  # Note that any chanes to `Error` should align with pipe operators.
end

