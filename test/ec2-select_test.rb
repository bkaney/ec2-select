require 'test_helper'

class Ec2SelectTest < Mini::Test::TestCase
  def test_show
    assert Ec2Select.show =~ /foob/
  end

  def test_rewrite_or_show
    assert_equal Ec2Select.rewrite_or_show, Ec2Select.show, "should show with no params"
  end
end
