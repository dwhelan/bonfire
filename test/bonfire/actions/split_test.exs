defmodule SplitTest do
  use Test, async: true

  import Split
  doctest Split

  test "split_one" do
    assert split_one({'1', ''}) == {'', '1'}
    assert split_one({'123', 'abc'}) == {'23', '1abc'}
    assert split_one({'', ''}) == nil
    assert split_one({'', 'abc'}) == nil
  end

  test "split_zero_or_more" do
    assert split_zero_or_more({'', ''}, DIGIT) == {'', ''}
    assert split_zero_or_more({'1', ''}, DIGIT) == {'', '1'}
  end

  test "split_one_or_more" do
    assert split_one_or_more({'1', ''}, &is_digit/1) == {'', '1'}
    assert split_one_or_more({'123', ''}, &is_digit/1) == {'', '321'}
    assert split_one_or_more({'123abc', ''}, &is_digit/1) == {'abc', '321'}
    assert split_one_or_more({'', ''}, &is_digit/1) == nil

    assert split_one_or_more({'a', ''}, ALPHA) == {'', 'a'}
#    assert split_one_or_more({'abc', ''}, ALPHA) == {'', 'cba'}
    assert split_one_or_more({'', ''}, ALPHA) == nil
  end
end
