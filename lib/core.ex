defmodule Guards do
  @spec is_octet(char) :: boolean
  defguard is_octet(char) when char >= 0 and char <= 255

  @spec is_alpha(char) :: boolean
  defguard is_alpha(char) when (char >= ?a and char <= ?z) or (char >= ?A and char <= ?Z)

  @spec is_digit(char) :: boolean
  defguard is_digit(char) when char >= ?0 and char <= ?9

  # (ALPHA / DIGIT / "-")
  @spec is_rulename_char(char) :: boolean
  defguard is_rulename_char(char) when is_alpha(char) or is_digit(char) or char === ?-
end

defmodule Core do
  @moduledoc false

  import Guards

  # rulename = ALPHA *(ALPHA / DIGIT / "-")
  def rulename([char | rest]) when is_alpha(char), do: rulename_tail(rest, [char])
  def rulename(_), do: nil
  defp rulename_tail([char | rest], acc) when is_rulename_char(char), do: rulename_tail(rest, [char | acc])
  defp rulename_tail(rest, acc), do: {token(:rulename, Enum.reverse(acc)), rest}

  defp token(type, value, code \\ nil, comments \\ nil) do
    %{
      type: type,
      value: value,
      code: code,
      comments: comments
    }
  end
end
