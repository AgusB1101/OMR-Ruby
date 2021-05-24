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

  has_one String, named: :full_name
  has_one Numeric, named: :grade

  def promoted
    grade >= 8
  end

  def has_last_name(last_name)
    self.full_name.split(' ')[1] === last_name
  end

end

agus = Person.new
agus.full_name = "Agustin Bernal"
agus.grade = 9
agus.save!

cami = Person.new
cami.full_name = "Camila Bernal"
cami.grade = 8
cami.save!

mama = Person.new
mama.full_name = "Corina Bouchet"
mama.grade = 6
mama.save!

Table.clear_all!