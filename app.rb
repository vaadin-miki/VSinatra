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

    # remember selected items
    @selection = session[:selection] ||= {}

  end

  post '/update' do
    puts "UPDATE #{params.inspect}"
    params[:value].nil? || params[:value].empty? ? @selection.delete(params[:id]) : @selection[params[:id]] = params[:value]
    puts "SELECT #{@selection.inspect}"

    people = Person.find_all.select { |p| (@selection["birthplace"].nil? || p.country == @selection["birthplace"]) && (@elements.date.value.nil? || @elements.date.value.empty? || p.year.to_s == @elements.date.value[0...4])}
    content_type "application/json", :charset => 'utf-8'
    with_this({grid: {items: people}}.to_json) {|x| puts "ANSWER #{x.inspect}"}
  end

  post '/~/:id' do
    case params["id"]
      when "person" then
        puts "-> PRS #{params['value']}"
        content_type("application/json")
        {birthplace: {value: (Person.find_by_id(params["value"]).country rescue "")}}.to_json
      else
        puts "NOT HANDLED - "+params.inspect
    end

  end

  get '/*' do

    @countries = %w{Poland Finland Germany}
    @people = Person.find_all

    @elements.date.label = "Pick a date. Only the year will be used."
    @elements.date.vaadin_events["value-changed"] = "update"

    @elements.grid.items = Person.find_all
    @elements.grid.columns = [{"name": "first_name"}, {"name": "last_name"}]
    erb :index
  end

  run! if app_file == $0

end