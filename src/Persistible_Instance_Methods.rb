require_relative 'tables/Table'
require_relative 'open_classes/Symbol'
require_relative 'Errors'

module PersistibleInstance
  attr_reader :id

  def save!
    if was_persisted?
      _update!
    end

    self.class.my_table.insert self
  end

  def refresh!
    unless was_persisted?
       raise ObjectNotPersistedError
    end

    last_saved = self.class.my_table.read(self.id)
    self.class.attr_persistibles.each { |key, attr| self.instance_variable_set attr.name.to_attr, last_saved.send(attr.name) }
    self
  end

  def forget!
    self.class.my_table.delete! self.id
    @id = nil
  end

  def _update!
    temp = self.id
    forget!
    @id = temp
  end

  def was_persisted?
    not id.nil?
  end
end