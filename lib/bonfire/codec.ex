defmodule Codec do
  import Split
  import Unsplit

  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
      import Split, unquote(opts)
      import Unsplit, unquote(opts)
    end
  end

  defmacro defcodec(codec_or_predicate) do
    quote do
      defsplit(unquote(codec_or_predicate), unquote(__CALLER__.module))
      defunsplit(unquote(codec_or_predicate), unquote(__CALLER__.module))
    end
  end

  defmacro defcodec(codec_or_predicate, do: block) do
    quote do
      defsplit(unquote(codec_or_predicate), unquote(__CALLER__.module))
      defunsplit(unquote(codec_or_predicate), unquote(__CALLER__.module))
    end
  end
end
