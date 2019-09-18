defmodule ZipTest do
  use Test, async: true

  import Zip
  doctest Zip

  test "zip_one_or_more" do
    assert zip_one_or_more({'', ''}, &is_digit/1) == nil
    assert zip_one_or_more({'1', ''}, &is_digit/1) == {'', '1'}
    assert zip_one_or_more({'123', ''}, &is_digit/1) == {'', '321'}
    assert zip_one_or_more({'123abc', ''}, &is_digit/1) == {'abc', '321'}
  end
end
