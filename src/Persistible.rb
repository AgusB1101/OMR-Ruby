require_relative 'Persistible_Instance_Methods'
require_relative 'Persistible_Class_Methods'
require_relative 'open_classes/Symbol'

module Persistible
  def self.included (base)
    base.include PersistibleInstance
    base.extend  PersistibleClass
  end
end

class Person
  include Persistible
  has_one String, named: :name
end

agus = Person.new
agus.name = "Agus"
agus.save!

puts "#{Person.my_table.table.entries}"

agus.name = "Agustin Bernal"
agus.save!
puts "#{Person.my_table.table.entries}"

Table.clear_all!