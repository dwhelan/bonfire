defmodule Codec do
  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
    end
  end

  defmacro defcodec_1_char(predicate) do
    [
      Decode.defdecode(__CALLER__.module, predicate),
      Encode.defencode(__CALLER__.module, predicate)
    ]
  end
end
