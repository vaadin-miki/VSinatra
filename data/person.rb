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
     JSON::parse(File.open('data/person.json', "r:UTF-8", &:read)).collect { |personMap| Person.new(personMap) }
   end

   def initialize(map = {})
     map.each {|key, value| self.send("#{key}=", value) if respond_to?("#{key}=")}
   end

   def display_name
     last_name ? "#{first_name} #{last_name}" : "#{first_name}"
   end
end