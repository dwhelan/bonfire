defmodule Codec do
  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
    end
  end

  defmacro defcodec1(predicate) do
    [
      Decode.defdecode1(__CALLER__.module, predicate),
      Encode.defencode1(__CALLER__.module, predicate)
    ]
  end
end
