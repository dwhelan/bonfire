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
- use operators
- use ABNF element comments: error messages? docs?
    - perhaps have `element.comments() :: binary` and `element.abnf() :: binary`
    - maybe other useful functions?   
- zip functions should expect lhs to be a list of charlists :: `{['first', 'second' | rest], 'charlist'}`
- compose actions

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bonfire](https://hexdocs.pm/bonfire).

