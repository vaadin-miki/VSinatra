require 'sinatra/base'
require 'tilt/erb'
require 'vaadin/elements'
require_relative 'data/person'

class VElementsApp < Sinatra::Base

  enable :sessions

  set :app_file, __FILE__
  set :server, ["webrick"]

  helpers Vaadin::ViewHelpers

  before do
    @elements ||= (session[:elements] ||= Vaadin::Elements.new)
    @elements.clear_changes
  end

  post '/update' do
    puts params.inspect
    @elements.sync(params)
    people = @elements.ignore_changes { Person.find_all.select { |p| (@elements.birthplace.value.nil? || @elements.birthplace.value.empty? || p.country == @elements.birthplace.value) && (@elements.date.value.nil? || @elements.date.value.empty? || p.year.to_s == @elements.date.value[0...4]) } }
    @elements.grid.items = people
    content_type "application/json", :charset => 'uitf-8'
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

  # post '/vaadin-dropdown-opened/:id' do
  #   puts "component with id #{params["id"]} was opened! parameters: #{params.inspect}"
  # end

  get '/*' do
    @elements.people.items = Person.find_all
    @elements.people.itemLabelPath=:display_name
    @elements.people.itemValuePath=:id
    @elements.people.vaadin_events << "value-changed"
    # @elements.people.vaadin_events["vaadin-dropdown-opened"] = "/:event/:id"

    @countries = %w{Poland Finland Germany}

    @elements.date.label = "Pick a date. Only the year will be used."
    @elements.date.vaadin_events["value-changed"] = "update"

    @elements.grid.items = Person.find_all
    @elements.grid.columns = [{"name": "first_name"}, {"name": "last_name"}]
    erb :index
  end

  run! if app_file == $0

end