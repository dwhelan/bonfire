defmodule Rule do
  defmacro __using__(opts \\ []) do
    quote do
      import Guards, unquote(opts)
      import Codec, unquote(opts)
      import Rule, unquote(opts)
    end
  end

  def shift_left({values, [char | rest]}) do
    {values ++ [char], rest}
  end

  def shift_right({[value | values], rest}) do
    {values, rest ++ [value]}
  end

  defmacro defcodec1(p) do
    quote do
      defmodule Decode do
        def apply([_ | _] = chars) do
          apply({[], chars})
        end

        def apply({_, [char | _]} = input) do
          case unquote(p).(char) do
            true -> shift_left(input)
            false -> nil
          end
        end

        def apply(_) do
          nil
        end
      end

      defmodule Encode do
        def apply([_ | _] = values) do
          apply({values, []})
        end

        def apply({[value | _], _} = input) do
          case unquote(p).(value) do
            true -> shift_right(input)
            false -> nil
          end
        end

        def apply(_) do
          nil
        end
      end
    end
  end

  defmacro defdecode1(p) do
    quote do
      defmodule Decode do
        def apply([_ | _] = chars) do
          apply({[], chars})
        end

        def apply({_, [char | _]} = input) do
          case unquote(p).(char) do
            true -> shift_left(input)
            false -> nil
          end
        end

        def apply(_) do
          nil
        end
      end
    end
  end

  defmacro defencode1(p) do
    quote do
      defmodule Encode do
        def apply([_ | _] = values) do
          apply({values, []})
        end

        def apply({[value | _], _} = input) do
          case unquote(p).(value) do
            true -> shift_right(input)
            false -> nil
          end
        end

        def apply(_) do
          nil
        end
      end
    end
  end
end
