require 'sinatra/base'
require 'tilt/erb'
require_relative 'vaadin-elements'
require_relative 'data/person'

class VElementsApp < Sinatra::Base

  enable :sessions
  set :session_secret, "asd"

  set :app_file, __FILE__
  set :server, ["webrick"]

  helpers Vaadin::ViewHelpers

  before do
    @elements ||= (session[:elements] ||= Vaadin::Elements.new)
    @elements.clear_changes
  end

  post '/update' do
    @elements.sync(params)
    case params["id"]
      when "birthplace" then
        @elements.grid.items = Person.find_all.select { |p| params["value"].nil? || params["value"].empty? || p.country == params["value"] }
      when "date" then
        @elements.grid.items = Person.find_all.select { |p| params["value"].nil? || params["value"].empty? || p.year.to_s == params["value"][0...4] }
      else
        puts "NOT HANDLED - "+params.inspect
    end
    content_type("application/json")
    @elements.changes_map.to_json
  end

  post '/~/:id' do
    @elements.sync(params)
    case params["id"]
      when "people" then
        @elements.birthplace.value = (Person.find_by_id(params["value"]).country rescue "")
      else
        puts "NOT HANDLED - "+params.inspect
    end

    content_type("application/json")
    @elements.changes_map.to_json
  end

  get '/*' do
    @elements.people.items = Person.find_all
    @elements.people.itemLabelPath=:display_name
    @elements.people.itemValuePath=:id

    @elements.birthplace.items = %w{Poland Finland elsewhere}
    @elements.birthplace.label = "Choose country of birth."
    @elements.birthplace.onValueChanged = "update"

    @elements.date.label = "Pick a date. Only the year will be used."
    @elements.date.onValueChanged = "update"

    @elements.grid.items = Person.find_all
    @elements.grid.columns = [{"name": "first_name"}, {"name": "last_name"}]
    erb :index
  end

  run! if app_file == $0

end