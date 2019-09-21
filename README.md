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
- complete split to handle multiple and return a list as the value 
- use pipe more -> first replace predicates with Codecs so return is {'', ''} or nil
- re-align MoveRight, RightTest and Merge, MergeTest
- complete dec-val
  - implement split
  - extend to num-val with other bases
- extend core to be an codec that takes arbitrary move and has move_left/1, move_one/1 functions  
- create a pipe operator for 'many'?
- rules
  if BNF for a rule has more than one rulename use the first for Codec and make others
  child modules so they are less visible?
- create ABNF parser that
  - checks validity to some extent
  - replaces ABNF with Elixir equivalents
  - using AST may not work due to explicitness of white space handling in ABNF
  - might be better to build a CODEC to parse ABNF
  - table below in ABNF order of operations shows a pre-parse that would allow `quote do end` to work
    
 | ABNF    | String replacement | As operator | AST handling |
 |:--- |:--- |:--- |:--- |
 | rule name    | `-` -> `_` and `upcase` first char? | |
 | prose-val    | `< x >` -> `@'x'` | `@` |
 | terminal values | | | |
 | : `%b`, `%x`, `%d` | `%b` -> `0b`<br>`%x` -> `0x`'<br> remove`%d`<br><br>works with ranges?|  | |
 | `.` concat| `1.2` -> `1 . 2`| `.` | convert to concatenation and retain base|
 |           | `~r/(%[bdx])(\d+)\.(\d+)/$1$2 $1$3`|  | ***apply before `%` matching*** |
 | `""` literal| | | |
 | `#` comment | `~r/#vchar*$/` ->  `+ '<match>'` | `+` unary| concatenate adjacent comments|
 | value range | `~r/(\d+)-(\d+)/$1..$2/` | | |
 | repetition| `~r/(\d+)*(\d+)/$1..$2 * /` | `*`| a*b element|
 |           | `~r/(\d+)*/$1..infinity * /` | `*`| a* element|
 |           | `~r/*(\d+)/0..$1 * /` | `*` | *a element|
 |           | `~r/(\d+)/$1..$1 * /` | `*` | n element|
 | grouping| | | assume Elixir `(` and `)` will handle|
 | optional| `~r/\[(.*)]/*1($1)/` |  | |
 | concatenation| `<sp>` -> `and`| `and`| |
 | alternative|`/` -> `or` | `or`| |
 
 
- create Pipe.macro to build pipe operators, use Pipe etc.

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

