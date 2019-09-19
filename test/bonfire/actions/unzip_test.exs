defmodule UnsplitTest do
  use Test, async: true

  import Unsplit
  doctest Unsplit

  test "unsplit_one" do
    assert unsplit_one({'', ''}) == nil
    assert unsplit_one({'', '1'}) == {'1', ''}
    assert unsplit_one({'', '12'}) == {'1', '2'}
    assert unsplit_one({'abc', '123'}) == {'1abc', '23'}
  end

  test "unsplit_one_or_more" do
    assert unsplit_one_or_more({'', ''}, &is_digit/1) == nil
    assert unsplit_one_or_more({'', '1'}, &is_digit/1) == {'1', ''}
    assert unsplit_one_or_more({'', '123'}, &is_digit/1) == {'321', ''}
    assert unsplit_one_or_more({'', '123abc'}, &is_digit/1) == {'321', 'abc'}
  end
end
