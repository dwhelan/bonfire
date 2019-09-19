defmodule DIGIT do
  @moduledoc """
  A codec for a `DIGIT`.

  ```
  DIGIT =  %x30-39 ; 0-9
  ```

  ## Examples

      iex> split '123'
      {'23', '1'}

      iex> split {'123', ''}
      {'23', '1'}

      iex> split {'23', '1'}
      {'3', '12'}

      iex> split {'3', '12'}
      {'', '123'}

      iex> merge '123'
      {'3', '12'}

      iex> merge {'', '123'}
      {'3', '12'}

      iex> merge {'3', '12'}
      {'23', '1'}

      iex> merge {'23', '1'}
      {'123', ''}
  """
  use Codec

  defcodec(&is_digit/1)
end
