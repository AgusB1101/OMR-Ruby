module Persistible
  def self.included
    include PersistibleInstance
    extend  PersistibleClass
  end
end
