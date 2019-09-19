defmodule Codec do
  import Zip
  import Unzip

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
      import Zip, unquote(opts)
      import Unzip, unquote(opts)
    end
  end

  defmacro defzipper(zipper_or_predicate) do
    quote do
      defzip(unquote(zipper_or_predicate), unquote(__CALLER__.module))
      defunzip(unquote(zipper_or_predicate), unquote(__CALLER__.module))
    end
  end

  defmacro defzipper(zipper_or_predicate, do: block) do
    quote do
      defzip(unquote(zipper_or_predicate), unquote(__CALLER__.module))
      defunzip(unquote(zipper_or_predicate), unquote(__CALLER__.module))
    end
  end
end
