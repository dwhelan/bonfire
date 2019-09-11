defmodule Guards do
  @spec is_octet(char) :: boolean
  defguard is_octet(char) when char >= 0 and char <= 255

  @spec is_alpha(char) :: boolean
  defguard is_alpha(char) when (char >= ?a and char <= ?z) or (char >= ?A and char <= ?Z)

  @spec is_digit(char) :: boolean
  defguard is_digit(char) when char >= ?0 and char <= ?9

  # From RFC 5234 8.1 Core Fields
  # (ALPHA / DIGIT / "-")
  @spec is_rulename_char(char) :: boolean
  defguard is_rulename_char(char) when is_alpha(char) or is_digit(char) or char === ?-
end

defmodule Core do
  @moduledoc false

  import Guards

  # rulename = ALPHA *(ALPHA / DIGIT / "-")
  def rulename(input) do
    case input do
      [char | rest] when is_alpha(char) ->
        {chars, rest} =
          Enum.reduce_while(rest, {[char], ''}, fn char, {chars, rest} ->
            case is_rulename_char(char) do
              true -> {:cont, {[char | chars], rest}}
              false -> {:halt, {chars, [char | rest]}}
            end
          end)

        {token(:rulename, Enum.reverse(chars)), rest}

      _ ->
        nil
    end
  end

  defp token(type, value, code \\ nil, comments \\ nil) do
    %{
      type: type,
      value: value,
      code: code,
      comments: comments
    }
  end
end
