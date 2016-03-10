require 'test/unit'
require_relative '../vaadin-elements'

class ElementsTest < Test::Unit::TestCase

  class AppMock
    include Vaadin::ViewHelpers
    attr_accessor :elements

    def initialize
      @elements = Vaadin::Elements.new
    end
  end

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @app = AppMock.new
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_import_view_helper
    js = @app.import_vaadin_elements
    assert_equal "<script src=\"http://polygit2.appspot.com/polymer+v1.3.1/vaadin-grid+vaadin+*/vaadin-combo-box+vaadin+*/vaadin-date-picker+vaadin+*/components/webcomponentsjs/webcomponents-lite.min.js\"></script>\n<script src=\"http://momentjs.com/downloads/moment.min.js\"></script>\n<link href=\"http://polygit2.appspot.com/polymer+v1.3.1/vaadin-grid+vaadin+*/vaadin-combo-box+vaadin+*/vaadin-date-picker+vaadin+*/components/vaadin-grid/vaadin-grid.html\" rel=\"import\">\n<link href=\"http://polygit2.appspot.com/polymer+v1.3.1/vaadin-grid+vaadin+*/vaadin-combo-box+vaadin+*/vaadin-date-picker+vaadin+*/components/vaadin-combo-box/vaadin-combo-box.html\" rel=\"import\">\n<link href=\"http://polygit2.appspot.com/polymer+v1.3.1/vaadin-grid+vaadin+*/vaadin-combo-box+vaadin+*/vaadin-date-picker+vaadin+*/components/vaadin-date-picker/vaadin-date-picker.html\" rel=\"import\">", js
  end

  def test_setup_view_helper
    @app.elements.grid.items = [{"name": "Ruby", "type": "dynamic"}, {"name": "Java", "type": "static"}]
    js = @app.setup_vaadin_elements
    assert_equal "function serverCallbackResponse(e) {\n\n         console.log(e);\n\n         var resp = JSON.parse(e);\n\n         for(var oid in resp) {\n\n           var comp = document.querySelector('#'+oid);\n\n           for(var meth in resp[oid]) {\n\n             if(meth in comp) {\n\n             comp[meth] = resp[oid][meth];\n\n       }}}};\ndocument.addEventListener(\"WebComponentsReady\", function (e) {\nvar grid = document.querySelector(\"#grid\");\nif('items' in grid) {\ngrid.items = [{\"name\":\"Ruby\",\"type\":\"dynamic\"},{\"name\":\"Java\",\"type\":\"static\"}]\n};\ngrid.addEventListener(\"value-changed\", function(e) {ajax.post(\"~/grid\", {id: 'grid', value: e.detail.value}, serverCallbackResponse)});\n});", js
  end

end