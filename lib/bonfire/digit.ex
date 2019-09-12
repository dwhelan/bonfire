defmodule Digit do
  @moduledoc """

  ## Examples

      iex> decode '123'
      {'1', '23'}

      iex> decode {'123', ''}
      {'1', '23'}

      iex> decode {'123', 'abc'}
      {'1', '23abc'}

      iex> decode :non_digit
      nil

      iex> encode '123'
      {'1', '23'}

      iex> encode {'123', ''}
      {'1', '23'}

      iex> encode {'123', 'abc'}
      {'1', '23abc'}

      iex> encode :non_digit
      nil
  """
  import Guards

  defmodule Decode do
    def apply({[char | chars], rest}) when is_digit(char) do
      {[char], chars ++ rest}
    end
  end

  defmodule Encode do
    def apply({[char | rest], foo}) when is_digit(char) do
      {[char], rest ++ foo}
    end
  end

  # could be in a defelement macro
  def decode([_ | _] = list) do
    decode({list, ''})
  end

  def decode({[char | rest], foo}) when is_digit(char) do
    {[char], rest ++ foo}
  end


  def decode({[char | rest], foo}) when is_digit(char) do
    Decode.apply {[char], rest ++ foo}
  end

  def decode(_) do
    nil
  end

  # could be in a defelement macro
  def encode([char | rest]) when is_digit(char) do
    {[char], rest}
  end

  def encode({[char | rest], foo}) when is_digit(char) do
    Encode.apply {[char], rest ++ foo}
  end

  def encode(_) do
    nil
  end
end
