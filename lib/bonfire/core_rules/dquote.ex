defmodule DQUOTE do
  @moduledoc """
  A codec for a `DQUOTE` (double quote).

  ```
  DQUOTE =  %x22 ; " (Double Quote)
  ```

  ## Examples

      iex> unsplit {'', '"'}
      {'"', ''}

      iex> unsplit {'', '_"'}
      nil

      iex> split {'"', ''}
      {'', '"'}
  """

  use Codec

  defcodec(?")
end
