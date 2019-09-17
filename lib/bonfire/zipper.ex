defmodule Zipper do
  import Zip
  import Unzip

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Zipper, unquote(opts)
      import Zip, unquote(opts)
      import Unzip, unquote(opts)
    end
  end

  defmacro defzipper(predicate) do
    quote do
      defzip(unquote(predicate), unquote(__CALLER__.module))
      defunzip(unquote(predicate), unquote(__CALLER__.module))
    end
  end
end
