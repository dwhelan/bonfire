defmodule ListProcessor.Error do
  @moduledoc """
  Represents a list processing error.

  Currently an error is simply represented as `nil`. This makes
  error handling simple.
  """
  @type t :: nil

  # Note that any changes to `ListProcessor.Error` should align with pipe operators and vice-versa.
end
