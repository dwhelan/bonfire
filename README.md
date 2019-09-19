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

- update ~>> operator to expect a function of arity 0. This may allow nice pipes like:
  (have predicates return value or nil)
```elixir
# from Split
  def split_one_or_more({[byte | _], _} = input, predicate) do
    case predicate.(byte) do
      true -> input |> split_one() |> split_zero_or_more(predicate)
      false -> nil
    end
  end
# hopefully
  def split_one_or_more({[byte | _], _} = input, can_split?) do
    byte
    ~> can_split?.()
    ~> split_one()
    ~> split_zero_or_more(can_split?)
  end

``` 
- a Codec should have an `apply` that is an identity function <- what FP representation? 
- use ABNF element comments: error messages? docs?
    - perhaps have `element.comments() :: binary` and `element.abnf() :: binary`
    - maybe other useful functions?   
- split functions should expect lhs to be a list of charlists :: `{['first', 'second' | rest], 'charlist'}`
- compose actions
- abstraction of property of `x | split() | merge() == x` for a pair of functions

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bonfire](https://hexdocs.pm/bonfire).

