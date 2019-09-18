defmodule UnzipTest do
  use Test, async: true

  import Unzip
  doctest Unzip

  test "one_or_more" do
    assert one_or_more({'', ''}, &is_digit/1) == nil
    assert one_or_more({'', '1'}, &is_digit/1) == {'1', ''}
    assert one_or_more({'', '123'}, &is_digit/1) == {'321', ''}
    assert one_or_more({'', '123abc'}, &is_digit/1) == {'321', 'abc'}
  end
end
