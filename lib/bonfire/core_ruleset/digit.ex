defmodule DIGIT do
  @moduledoc """
  A codec for a `DIGIT`.

  ```
  DIGIT =  %x30-39 ; 0-9
  ```

  ## Examples

      iex> unzip '123'
      {'1', '23'}

      iex> unzip {'', '123'}
      {'1', '23'}

      iex> unzip {'1', '23'}
      {'12', '3'}

      iex> unzip {'12', '3'}
      {'123', ''}

      iex> zip '123'
      {'23', '1'}

      iex> zip {'123', ''}
      {'23', '1'}

      iex> zip {'23', '1'}
      {'3', '12'}

      iex> zip {'3', '12'}
      {'', '123'}
  """
  use Zipper

  defcodec(&is_digit/1)
end
