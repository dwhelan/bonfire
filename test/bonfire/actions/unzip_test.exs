defmodule UnzipTest do
  use Test, async: true

  import Unzip
  doctest Unzip

  test "unzip_one" do
    assert unzip_one({'', ''}) == nil
    assert unzip_one({'', '1'}) == {'1', ''}
    assert unzip_one({'', '12'}) == {'1', '2'}
    assert unzip_one({'abc', '123'}) == {'1abc', '23'}
  end

  test "unzip_one_or_more" do
    assert unzip_one_or_more({'', ''}, &is_digit/1) == nil
    assert unzip_one_or_more({'', '1'}, &is_digit/1) == {'1', ''}
    assert unzip_one_or_more({'', '123'}, &is_digit/1) == {'321', ''}
    assert unzip_one_or_more({'', '123abc'}, &is_digit/1) == {'321', 'abc'}
  end
end
