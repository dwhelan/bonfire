defmodule SplitTest do
  use Test, async: true

  import Split
  doctest Split

  test "split_one/1" do
    assert split_one({'a', ''}) == {'', 'a'}
    assert split_one({'ab', '_'}) == {'b', 'a_'}
    assert split_one({'', ''}) == nil
    assert split_one({'', '_'}) == nil
  end

  test "split_one/2" do
    assert split_one({'a', ''}, fn _ -> true end) == {'', 'a'}
    assert split_one({'a', ''}, fn _ -> false end) == nil

    assert split_one({'a', ''}, &(not is_boolean &1)) == {'', 'a'}
    assert split_one({'a', ''}, &(is_boolean &1)) == nil

    assert split_one({'a', ''}, ALPHA) == {'', 'a'}
    assert split_one({'a', ''}, DIGIT) == nil
  end

  test "split_zero_or_more/2" do
    assert split_zero_or_more({'', ''}, DIGIT) == {'', ''}
    assert split_zero_or_more({'1', ''}, DIGIT) == {'', '1'}
  end

  test "split_one_or_more" do
    assert split_one_or_more({'a', ''}, &is_alpha/1) == {'', 'a'}
    assert split_one_or_more({'abc', ''}, &is_alpha/1) == {'', 'cba'}
    assert split_one_or_more({'abc123', ''}, &is_alpha/1) == {'123', 'cba'}
    assert split_one_or_more({'', ''}, &is_alpha/1) == nil

    assert split_one_or_more({'a', ''}, ALPHA) == {'', 'a'}
#    assert split_one_or_more({'abc', ''}, ALPHA) == {'', 'cba'}
    assert split_one_or_more({'', ''}, ALPHA) == nil
  end
end
