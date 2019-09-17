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
- a Zipper should have an `apply` that is an identity function <- what FP representation a 
- use ABNF element comments: error messages? docs?
    - perhaps have `element.comments() :: binary` and `element.abnf() :: binary`
    - maybe other useful functions?   
- zip functions should expect lhs to be a list of charlists :: `{['first', 'second' | rest], 'charlist'}`
- compose actions
- abstraction of property of `x | zip() | unzip() == x` for a pair of functions

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bonfire](https://hexdocs.pm/bonfire).

