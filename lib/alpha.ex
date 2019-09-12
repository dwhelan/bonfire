defmodule Alpha do
  @moduledoc """

  ## Examples

      iex> decode 'a'
      {'a', ''}
  """
  import Guards

  def decode([char | rest]) when is_alpha(char) do
    {[char], rest}
  end

  def decode(_) do
    nil
  end
end
