defmodule Split do
  @moduledoc """
  Functions and macros for splitting.
  """
  import Pipes
  import Lists

  @callback apply(any) :: {[byte], [byte, ...]} | nil

  defmacro defsplit(type, codec \\ __CALLER__.module) do
    [
      create_split_functions(codec),
      create_split_module(type)
    ]
  end

  defp create_split_functions(codec) do
    quote do
      @spec split(nonempty_list(byte)) :: {[byte], [byte, ...]} | nil
      def split([_ | _] = source) do
        split({source, []})
      end

      @spec split({[byte, ...], [byte]}) :: {[byte], [byte, ...]} | nil
      def split(input) do
        input
        ~> reverse_dest()
        ~> apply_split()
        ~> reverse_dest()
      end

      @spec apply_split({[byte, ...], [byte]}) :: {[byte], [byte, ...]} | nil
      def apply_split(input) do
        unquote(codec).Split.apply(input)
      end

      defp reverse_dest({source, dest}) do
        {source, Enum.reverse(dest)}
      end
    end
  end

  defp create_split_module({:&, _, _} = predicate) do
    create_module(
      quote do
        def apply({[byte | rest], dest} = input) do
          split_one(input, unquote(predicate))
        end
      end
    )
  end

  defp create_split_module(byte) do
    create_module(
      quote do
        def apply({[unquote(byte) | rest] = source, dest} = input) do
          split_one(input)
        end
      end
    )
  end

  defp create_module(block) do
    # Not using Module.create/3 because it seems simpler to just inject the new module
    # rather than trying to computes its name.
    quote do
      defmodule Split do
        @moduledoc false
        import :"Elixir.Split"

        @behaviour :"Elixir.Split"

        @impl :"Elixir.Split"
        unquote(block)

        def apply(_) do
          nil
        end
      end
    end
  end

  def split_one({[byte | rest], dest}) do
    {rest, [byte | dest]}
  end

  def split_one(_) do
    nil
  end

  def split_one(input, codec) when is_atom(codec) do
    codec.apply_split(input)
  end

  def split_one(input, predicate) do
    input
    ~> pipe_predicate(predicate)
    ~> split_one()
  end

  def split_one_or_more(input, splitter) do
    input
    ~> split_one(splitter)
    ~> split_zero_or_more(splitter)
  end

  def split_zero_or_more(input, splitter) do
    input
    ~> split_one(splitter)
    ~> split_zero_or_more(splitter)
    ~>> (fn _ -> input end).()
  end

  defp pipe_predicate({[byte | _], _} = input, predicate) do
    case predicate.(byte) do
      true -> input
      false -> nil
    end
  end

  defp pipe_predicate(_, _) do
    nil
  end

  def split_zero_or_more(input, splitter) do
    input
    ~> split_one_or_more(splitter)
    ~>> return(input)
  end

  def split_one_or_more(input, splitter) do
    input
    ~> split_one(splitter)
    ~> wrap_right()
    ~> _split_zero_or_more(splitter)
  end

  defp _split_zero_or_more(input, splitter) do
    input
    ~> split_one(splitter)
    ~> insert_right()
    ~> _split_zero_or_more(splitter)
    ~>> return(input)
  end

  defp return(_, result) do
    result
  end
end
