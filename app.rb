require 'sinatra/base'
require 'tilt/erb'
require 'vaadin/elements'
require_relative 'data/person'

class VElementsApp < Sinatra::Base

  enable :sessions

  set :app_file, __FILE__
  set :server, ['webrick']

  helpers Vaadin::ViewHelpers

  before do
    # remember selected items
    @selection = session[:selection] ||= {}
    session[:people] = (1...100).to_a unless session[:people]
    @people = session[:people].collect { |p| Person.find_by_id(p) }
  end

  post '/update' do
    puts "UPDATE #{params.inspect}"
    params[:value].nil? || params[:value].empty? ? @selection.delete(params[:id]) : @selection[params[:id]] = params[:value]
    puts "SELECT #{@selection.inspect}"

    session[:people] = Person.find_all.select { |p| (@selection['birthplace'].nil? || p.country == @selection['birthplace']) && (@selection['date'].nil? || p.year.to_s == @selection['date'][0...4]) }.collect { |p| p.id }

    content_type 'application/json', :charset => 'utf-8'

    # this only works for lazy loaded
    with_this({grid: {refreshItems: nil}}.to_json) { |x| puts "ANSWER #{x.inspect}" }
    # this works for non-lazy-loading
    # @people = Person.find_all...
    # with_this({grid: {items: @people}}.to_json) {|x| puts "ANSWER #{x.inspect}"}
  end

  # lazy load here
  post '/people' do
    puts params.inspect
    content_type 'application/json', :charset => 'utf-8'
    with_this({result: @people[params['index'].to_i, params['count'].to_i], size: @people.size}.to_json) { |x| puts "ANSWER #{x.inspect}" }
  end

  post '/~/:id' do
    case params['id']
      when 'person' then
        content_type('application/json')
        {birthplace: {value: (Person.find_by_id(params['value']).country rescue '')}}.to_json
      when 'grid' then
        puts "Grid submitted the following: #{params.inspect}"
        content_type('application/json')
        {}.to_json
      else
        puts 'NOT HANDLED - '+params.inspect
    end

  end

  get '/*' do
    @countries = %w{Poland Finland Germany}
    erb :index
  end

  run! if app_file == $0

end