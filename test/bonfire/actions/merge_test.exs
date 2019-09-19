defmodule MergeTest do
  use Test, async: true

  import Merge
  doctest Merge

  test "merge_one" do
    assert merge_one({'', ''}) == nil
    assert merge_one({'', '1'}) == {'1', ''}
    assert merge_one({'', '12'}) == {'1', '2'}
    assert merge_one({'abc', '123'}) == {'1abc', '23'}
  end

  test "merge_one_or_more" do
    assert merge_one_or_more({'', ''}, &is_digit/1) == nil
    assert merge_one_or_more({'', '1'}, &is_digit/1) == {'1', ''}
    assert merge_one_or_more({'', '123'}, &is_digit/1) == {'321', ''}
    assert merge_one_or_more({'', '123abc'}, &is_digit/1) == {'321', 'abc'}
  end
end
