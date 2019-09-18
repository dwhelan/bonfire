defmodule DecVal do
  @moduledoc """
  A zipper for a `dec-val`.

  ```
  dec-val = "d" 1*DIGIT [ 1*("." 1*DIGIT) / ("-" 1*DIGIT) ]
  ```

  ## Examples

      iex> unzip {'', '%d1'}
      {'%d1', ''}

      iex> unzip {'', '%d123'}
      {'%d123', ''}

      iex> unzip {'', 'foo'}
      nil
  """

  use Zipper

  defunzip do
    def apply({dest, [?%, ?d | rest]}) do
      unzip_one_or_more({[?d, ?% | dest], rest}, &is_digit/1)
    end
  end
end
