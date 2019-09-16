defmodule Zipper do
  import Unzip
  import Zip

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Zipper, unquote(opts)
      import Unzip
      import Zip
    end
  end

  defmacro defcodec(predicate) do
    quote do
      defdecode(unquote(predicate), unquote(__CALLER__.module))
      defencode(unquote(predicate), unquote(__CALLER__.module))
    end
  end
end
