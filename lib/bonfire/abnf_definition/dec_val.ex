defmodule DecVal do
  @moduledoc """
  A codec for a `dec-val`.

  ```
  dec-val = "d" 1*DIGIT [ 1*("." 1*DIGIT) / ("-" 1*DIGIT) ]
  ```

  ## Examples

     # iex> merge {'', '%d1'}
     # {'%d1', ''}

     # iex> merge {'', '%d123'}
     # {'%d123', ''}

      iex> merge {'', 'foo'}
      nil
  """

  use Codec

  defmerge do
    def apply({dest, [?%, ?d | rest]}) do
      merge_one_or_more({[?d, ?% | dest], rest}, &is_digit/1)
    end
  end
end
