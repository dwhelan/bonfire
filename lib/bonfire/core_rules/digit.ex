defmodule DIGIT do
  @moduledoc """
  A codec for a `DIGIT`.

  ```
  DIGIT =  %x30-39 ; 0-9
  ```

  ## Examples

      iex> unsplit '123'
      {'1', '23'}

      iex> unsplit {'', '123'}
      {'1', '23'}

      iex> unsplit {'1', '23'}
      {'12', '3'}

      iex> unsplit {'12', '3'}
      {'123', ''}

      iex> split '123'
      {'23', '1'}

      iex> split {'123', ''}
      {'23', '1'}

      iex> split {'23', '1'}
      {'3', '12'}

      iex> split {'3', '12'}
      {'', '123'}
  """
  use Codec

  defcodec(&is_digit/1)
end
