defmodule Foo do
  defguard is_alpha(char) when (char >= 0x41 and char <= 0x5A) or (char >= 0x61 and char <= 0x7A)
end

defmodule Core do
  @moduledoc false

  import Bonfire

  defrule "CR = %x0D"

  def name(input) do
    case input do
      [char | rest] ->
        if Core.alpha?(char) do
          name_tail(rest, [char])
        else
          nil
        end

      _ ->
        nil
    end
  end

  defp name_tail(input, acc) do
    case input do
      [char | rest] ->
        if Core.alpha?(char) or Core.digit?(char) or char === ?- do
          name_tail(rest, [char | acc])
        else
          {token(:name, Enum.reverse(acc)), input}
        end

      _ ->
#        {token(:name, Util.name(Enum.reverse(acc))), input}
        {token(:name, Enum.reverse(acc)), input}
    end
  end

  defp token(type, value, comments \\ nil) do
    %{
      element: type,
      value: value,
      code: nil,
      comments: comments
    }
  end

  @spec alpha?(char) :: boolean
  def alpha?(char) do
    (char >= 0x41 and char <= 0x5A) or
      (char >= 0x61 and char <= 0x7A)
  end

end
