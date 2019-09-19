# Bonfire

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bonfire` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bonfire, "~> 0.1.0"}
  ]
end
```

## To do

- rename Codec -> Codec, Unzip -> Split, Zip -> Merge
- rename source -> charlist, dest -> split?
- reverse {source, dest} -> {dest, source}
- better => rename Unzip -> Merge, Zip -> Split (as this will reverse args so we don't need to munge code)

- update ~>> operator to expect a function of arity 0. This may allow nice pipes like:
```elixir
# from Zip
  def zip_one_or_more({[byte | _], _} = input, predicate) do
    case predicate.(byte) do
      true -> input |> zip_one() |> zip_zero_or_more(predicate)
      false -> nil
    end
  end
# hopefully
  def zip_one_or_more({[byte | _], _} = input, can_zip?) do
    byte
    ~> can_zip?.()
    ~> zip_one()
    ~> zip_zero_or_more(can_zip?)
  end

``` 
- a Codec should have an `apply` that is an identity function <- what FP representation? 
- use ABNF element comments: error messages? docs?
    - perhaps have `element.comments() :: binary` and `element.abnf() :: binary`
    - maybe other useful functions?   
- zip functions should expect lhs to be a list of charlists :: `{['first', 'second' | rest], 'charlist'}`
- compose actions
- abstraction of property of `x | zip() | unzip() == x` for a pair of functions

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bonfire](https://hexdocs.pm/bonfire).

