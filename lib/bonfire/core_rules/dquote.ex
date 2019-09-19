defmodule DQUOTE do
  @moduledoc """
  A codec for a `DQUOTE` (double quote).

  ```
  DQUOTE =  %x22 ; " (Double Quote)
  ```

  ## Examples

      iex> unzip {'', '"'}
      {'"', ''}

      iex> unzip {'', '_"'}
      nil

      iex> zip {'"', ''}
      {'', '"'}
  """

  use Codec

  defcodec(?")
end
