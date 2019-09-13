defmodule Codec do
  defmacro defcodec do
    quote do
      def decode(input) do
        unquote(__CALLER__.module).Decode.apply(input)
      end

      def encode(input) do
        unquote(__CALLER__.module).Encode.apply(input)
      end
    end
  end
end
