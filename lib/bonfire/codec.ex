defmodule Codec do
  import Decode
  import Encode

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
      import Decode
      import Encode
    end
  end

  defmacro defcodec(predicate) do
    quote do
      defdecode(unquote(predicate), unquote(__CALLER__.module))
      defencode(unquote(predicate), unquote(__CALLER__.module))
    end
  end
end
