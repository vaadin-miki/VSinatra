require 'sinatra'
require 'tilt/erb'
require_relative 'vaadin-elements'
require_relative 'data/person'

before do
  @elements ||= Vaadin::Elements.new
end

helpers do
  def import_vaadin_elements(*elements)
    elements = Vaadin::Elements::AVAILABLE if elements.empty?
    path_elements = elements + ["components"]
    path_base = "http://polygit2.appspot.com/polymer+v1.3.1/" + path_elements.join("+vaadin+*/")+"/"
    (["<script src=\"#{path_base}webcomponentsjs/webcomponents-lite.min.js\"></script>",
      "<script src=\"http://momentjs.com/downloads/moment.min.js\"></script>"
    ]+elements.collect {|element| "<link href=\"#{path_base}#{element}/#{element}.html\" rel=\"import\">"}).join("\n")
  end
end

post '/~' do
  case params["id"]
    when "people" then @elements.birthplace.value = (Person.find_by_id(params["value"]).country rescue "")
    when "birthplace" then @elements.grid.items = Person.find_all.select {|p| params["value"].nil? || params["value"].empty? || p.country == params["value"]}
    when "date" then @elements.grid.items = Person.find_all.select {|p| params["value"].nil? || params["value"].empty? || p.year.to_s == params["value"].split(/\s+/)[3]}
    else puts "NOT HANDLED - "+params.inspect
  end

  content_type("application/json")
  @elements.to_json
end

get '/*' do

  @elements.people.items = Person.find_all
  @elements.people.itemLabelPath=:display_name
  @elements.people.itemValuePath=:id

  @elements.birthplace.items = %w{Poland Finland elsewhere}
  @elements.birthplace.label = "Choose country of birth."

  @elements.date.label = "Pick a date. Only the year will be used."

  @elements.grid.items = Person.find_all
  @elements.grid.columns = [{"name": "first_name"}, {"name": "last_name"}]
  erb :index
end