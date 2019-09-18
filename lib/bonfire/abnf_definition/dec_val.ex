defmodule DecVal do
  @moduledoc """
  A zipper for a `dev-val`.

  ```
  dec-val = "d" 1*DIGIT [ 1*("." 1*DIGIT) / ("-" 1*DIGIT) ]
  ```

  ## Examples

  """

  use Zipper

#  defunzip('d1') do
#    def apply({dest, [?%, ?d | rest]} = input) do
#      num_val_tail({[?d, ?% | dest], rest}, &is_digit/1)
#    end
#
#    defp num_val_tail({dest, [digit | rest]}, predicate) do
#      case num(source, base) do
#        nil ->
#          nil
#
#        {n, [?. | _] = rest} ->
#          num_concat_tail(rest, base, [n])
#
#        {from, [?- | rest]} ->
#          case num(rest, base) do
#            nil -> nil
#            {to, rest} -> {token(:num_range, %{from: from, to: to}), rest}
#          end
#
#        {n, rest} ->
#          {token(:num_range, %{from: n, to: n}), rest}
#      end
#    end
#
#    defp num_concat_tail(input, base, acc) do
#      case input do
#        [?. | rest] ->
#          case num(rest, base) do
#            nil -> {token(:num_concat, Enum.reverse(acc)), input}
#            {n, rest} -> num_concat_tail(rest, base, [n | acc])
#          end
#
#        _ ->
#          {token(:num_concat, Enum.reverse(acc)), input}
#      end
#    end
#
#    defp num({dest, [byte, rest]}, predicate) do
#      byte
#      |> predicate.()
#      ~> fn _ -> num_tail({[byte | dest], rest}, predicate) end
#    end
#
#    defp num_tail(input, base, acc) do
#      case input do
#        [char | rest] ->
#          if is_num?(char, base) do
#            num_tail(rest, base, [char | acc])
#          else
#            {to_i(Enum.reverse(acc), base), input}
#          end
#
#        _ ->
#          {to_i(Enum.reverse(acc), base), input}
#      end
#    end
#end
end
