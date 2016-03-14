# these are models for test environment
require 'vaadin/jsonise'

class Person
   attr_accessor :first_name, :last_name, :city, :country, :id, :year
   include Jsonise
   json_virtual_attributes :display_name

   # @return [Person] that has the given id, or nil
   def self.find_by_id(id)
     find_all.find {|x| x.id.to_s == id.to_s}
   end


   # @return [[Person]]s from the table
   def self.find_all
     ["Jan Kowalski Poland 1980", "Anna Nowak Poland 1982", "Tomasz Malinowski Finland 2012", "Krzysztof Kozłowski Finland 2014", "Julia Stasiak Finland 2014"].
         collect {|name| name.split(/\s+/)}.
         collect {|data| Person.new({"first_name": data.first, "last_name": data[1], "country": data[2], "year": data[3]})}.each_with_index {|person, index| person.id = index+1}
   end

   def initialize(map = {})
     map.each {|key, value| self.send("#{key}=", value) if respond_to?("#{key}=")}
   end

   def display_name
     last_name ? "#{first_name} #{last_name}" : "#{first_name}"
   end
end