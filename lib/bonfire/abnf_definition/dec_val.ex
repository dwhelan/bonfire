defmodule DecVal do
  @moduledoc """
  A codec for a `dec-val`.

  ```
  dec-val = "d" 1*DIGIT [ 1*("." 1*DIGIT) / ("-" 1*DIGIT) ]
  ```

  ## Examples

      iex> unsplit {'', '%d1'}
      {'%d1', ''}

      iex> unsplit {'', '%d123'}
      {'%d123', ''}

      iex> unsplit {'', 'foo'}
      nil
  """

  use Codec

  defunsplit do
    def apply({dest, [?%, ?d | rest]}) do
      unsplit_one_or_more({[?d, ?% | dest], rest}, &is_digit/1)
    end
  end
end
