defmodule DQUOTE do
  @moduledoc """
  A codec for a `DQUOTE` (double quote).

  ```
  DQUOTE =  %x22 ; " (Double Quote)
  ```

  ## Examples

      iex> merge {'', '"'}
      {'"', ''}

      iex> merge {'', 'x'}
      nil

      iex> split {'"', ''}
      {'', '"'}
  """

  use Codec

  defcodec(?")
end
