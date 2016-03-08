require 'test/unit'

require_relative '../jsonise'
require_relative '../data/person'

class Model
  include Jsonise
  attr_accessor :text, :number
end

class JsoniseTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @model = Model.new
    @model.text = "Something"
    @model.number = 42
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_to_json
    assert_equal "{\"number\":42,\"text\":\"Something\"}", @model.to_json
  end

  def test_from_json
    @other = Model.new.from_json("{\"number\":42,\"text\":\"Something\"}")
    assert_equal(@model.text, @other.text)
    assert_equal(@model.number, @other.number)
  end

  def test_array_to_json
    assert_equal "[{\"number\":42,\"text\":\"Something\"}]", [@model].to_json
  end

  def test_people_to_json
    assert_equal "[{\"display_name\":\"Miki\",\"first_name\":\"Miki\",\"last_name\":\"Olsz\"},{\"display_name\":\"Tusiek \",\"first_name\":\"Tusiek\"}]", [Person.new({"first_name": "Miki", "last_name":"Olsz"}), Person.new({"first_name":"Tusiek"})].to_json
  end

end