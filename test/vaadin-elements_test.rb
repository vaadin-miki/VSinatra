require 'test/unit'
require_relative '../vaadin-elements'

class ExtensionsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @map = Vaadin::Elements.new
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_assign
    @map.foo = "bar"
    assert_equal "bar", @map.foo
  end

  def test_nested_assign
    @map.foo.bar = "hello!"
    assert_equal "hello!", @map.foo.bar
    assert_equal({"bar" => "hello!"}, @map.foo)
  end
end