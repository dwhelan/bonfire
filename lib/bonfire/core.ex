defmodule Core do
  @moduledoc false

  import Guards

  def repetition(input, from: from, to: to) do
  end

  # rulename = ALPHA *(ALPHA / DIGIT / "-")
  def rulename(chars) do
    decode(chars, :rulename, &is_alpha/1, &is_rulename_char/1)
  end

  defp decode_zero_or_more(chars, acc, is_valid?) do
    {chars, rest} =
      Enum.reduce_while(chars, {acc, ''}, fn char, {acc, rest} ->
        case is_valid?.(char) do
          true -> {:cont, {[char | acc], rest}}
          false -> {:halt, {acc, [char | rest]}}
        end
      end)

    {Enum.reverse(chars), rest}
  end

  defp decode_one([char | rest], is_valid?) do
    case is_valid?.(char) do
      true -> {[char], rest}
      false -> nil
    end
  end

  defp decode_one(_, _) do
    nil
  end

  defp decode(input, type, first, subsequent) do
    case input do
      [char | rest] ->
        case first.(char) do
          true ->
            {chars, rest} = decode_zero_or_more(rest, [char], subsequent)
            {token(type, chars), rest}

          false ->
            nil
        end

      _ ->
        nil
    end
  end

  defp token(type, chars) do
    %{
      type: type,
      chars: chars
    }
  end
end
