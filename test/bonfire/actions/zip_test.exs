defmodule SplitTest do
  use Test, async: true

  import Split
  doctest Split

  test "zip_one" do
    assert zip_one({'1', ''}) == {'', '1'}
    assert zip_one({'123', 'abc'}) == {'23', '1abc'}
    assert zip_one({'', ''}) == nil
    assert zip_one({'', 'abc'}) == nil
  end

  test "zip_zero_or_more" do
    assert zip_zero_or_more({'', ''}, DIGIT) == {'', ''}
    assert zip_zero_or_more({'1', ''}, DIGIT) == {'', '1'}
  end

  test "zip_one_or_more" do
    assert zip_one_or_more({'', ''}, &is_digit/1) == nil
    assert zip_one_or_more({'1', ''}, &is_digit/1) == {'', '1'}
    assert zip_one_or_more({'123', ''}, &is_digit/1) == {'', '321'}
    assert zip_one_or_more({'123abc', ''}, &is_digit/1) == {'abc', '321'}

    assert zip_one_or_more({'a', ''}, ALPHA) == {'', 'a'}
    assert zip_one_or_more({'abc', ''}, ALPHA) == {'', 'cba'}
    assert zip_one_or_more({'', ''}, ALPHA) == nil

  end
end
