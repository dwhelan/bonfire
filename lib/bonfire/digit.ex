defmodule Digit do
  @moduledoc """

  ## Examples

      iex> decode '123'
      {'1', '23'}

      iex> decode :non_digit
      nil

      iex> encode '123'
      {'1', '23'}

      iex> encode :non_digit
      nil
  """
  import Guards

  def decode([char | rest]) when is_digit(char) do
    {[char], rest}
  end

  def decode(_) do
    nil
  end

  def encode([char | rest]) when is_digit(char) do
    {[char], rest}
  end

  def encode(_) do
    nil
  end
end
