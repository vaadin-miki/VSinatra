require 'test/unit'
require_relative '../core-extensions'

class CoreExtensionsTest < Test::Unit::TestCase

  class MockHash < Hash
    include HashKeysAsMethods
    include RememberHashChanges
  end

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @map = MockHash.new
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

  def test_changed_attributes
    @map.foo = "bar"
    @map.bar.baz = "hello"
    @map.bar.gee = "ohai"
    assert_equal ["foo", "bar"], @map.changed_attributes
  end

  def test_changes_map
    @map.foo = "bar"
    @map.bar.baz = "hello"
    @map.bar.gee = "ohai"
    assert_equal({"foo" => "bar", "bar" => {"baz" => "hello", "gee" => "ohai"}}.to_a, @map.changes_map.to_a)
  end

  def test_modified_changes_map
    @map.ignore_changes = true
    @map.foo = "bar"
    @map.stare = "old"
    @map.bar.baz = "hello"
    @map.bar.gee = "ohai"
    @map.ignore_changes = false
    @map.foo = "BAR!"
    @map.nowe = "this new"
    @map.bar.gee = "NO WAI"

    assert_equal({"foo" => "BAR!", "nowe" => "this new", "bar" => {"gee" => "NO WAI"}}.to_a, @map.changes_map.to_a)
  end

  def test_nested_changes_map
    @map.this.is.sparta = "ohai"
    @map.ignore_changes = true
    @map.this.is.not = "sparta"
    assert_true(@map.has_changes?)
  end

  def test_ignore_changes_block
    @map.ignore_changes { @map.foo = "bar" }
    assert_false(@map.has_changes?)
    assert_true(!@map.ignore_changes)
  end

end