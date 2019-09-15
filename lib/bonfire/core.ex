defmodule Core do
  @moduledoc false

  import Guards

  def repetition(input, from: from, to: to) do
  end

  # rulename = ALPHA *(ALPHA / DIGIT / "-")
  def rulename(bytes) do
    decode(bytes, :rulename, &is_alpha/1, &is_rulename_char/1)
  end

  defp decode_zero_or_more(bytes, acc, is_valid?) do
    {bytes, rest} =
      Enum.reduce_while(bytes, {acc, ''}, fn byte, {acc, rest} ->
        case is_valid?.(byte) do
          true -> {:cont, {[byte | acc], rest}}
          false -> {:halt, {acc, [byte | rest]}}
        end
      end)

    {Enum.reverse(bytes), rest}
  end

  defp decode_one([byte | rest], is_valid?) do
    case is_valid?.(byte) do
      true -> {[byte], rest}
      false -> nil
    end
  end

  defp decode_one(_, _) do
    nil
  end

  defp decode(input, type, first, subsequent) do
    case input do
      [byte | rest] ->
        case first.(byte) do
          true ->
            {bytes, rest} = decode_zero_or_more(rest, [byte], subsequent)
            {token(type, bytes), rest}

          false ->
            nil
        end

      _ ->
        nil
    end
  end

  defp token(type, bytes) do
    %{
      type: type,
      bytes: bytes
    }
  end
end
