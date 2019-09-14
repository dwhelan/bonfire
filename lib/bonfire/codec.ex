defmodule Codec do
  import Decode
  import Encode

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
    end
  end

  defmacro defcodec(predicate) do
    [
      defdecode(__CALLER__.module, predicate),
      defencode(__CALLER__.module, predicate)
    ]
  end
end
