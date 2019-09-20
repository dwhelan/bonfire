defmodule RightTest do
  use Test, async: true

  import Right
  doctest Right

  defp _true(_), do: true
  defp _false(_), do: false

  test "move_zero_or_more/2" do
    assert move_zero_or_more({'', '_'}, ALPHA) == {'', '_'}
    assert move_zero_or_more({'a', '_'}, ALPHA) == {'', ['a', ?_]}
    assert move_zero_or_more({'ab', '_'}, ALPHA) == {'', ['ba', ?_]}
    assert move_zero_or_more({'1', '_'}, ALPHA) == {'1', '_'}

    assert move_zero_or_more({'', '_'}, &_true/1) == {'', '_'}
    assert move_zero_or_more({'a', '_'}, &_true/1) == {'', ['a', ?_]}
    assert move_zero_or_more({'ab', '_'}, &_true/1) == {'', ['ba', ?_]}
    assert move_zero_or_more({'a', '_'}, &_false/1) == {'a', '_'}
  end

  test "move_one_or_more" do
    assert move_one_or_more({'a', ''}, &is_alpha/1) == {'', ['a']}
    assert move_one_or_more({'ab', ''}, &is_alpha/1) == {'', ['ba']}
    assert move_one_or_more({'ab12', ''}, &is_alpha/1) == {'12', ['ba']}
    assert move_one_or_more({'', ''}, &is_alpha/1) == nil

    assert move_one_or_more({'a', '_'}, ALPHA) == {'', ['a', ?_]}
    assert move_one_or_more({'ab', ''}, ALPHA) == {'', ['ba']}
    assert move_one_or_more({'ab12', ''}, ALPHA) == {'12', ['ba']}
    assert move_one_or_more({'', ''}, ALPHA) == nil
  end
end
