defmodule Alpha do
  @moduledoc """

  ## Examples

      iex> decode 'abc'
      {'a', 'bc'}

      iex> decode :non_alpha
      nil

      iex> encode 'abc'
      {'a', 'bc'}
  """
  import Guards

  def decode([char | rest]) when is_alpha(char) do
    {[char], rest}
  end

  def decode(_) do
    nil
  end

  def encode([char | rest]) when is_alpha(char) do
    {[char], rest}
  end

  def encode(_) do
    nil
  end
end
