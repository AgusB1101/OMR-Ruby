require_relative 'tables/Table'
require_relative 'open_classes/Symbol'
require_relative 'errors'

module PersistibleInstance
  attr_reader :id

  def save!
    if was_persisted?
      _update!
    end

    self.class.my_table.insert self
  end

  def refresh!
    if was_persisted?
      last_saved = self.class.my_table.read(self.id)
      self.attr_persistibles.each { |_, attr| self.send attr.name.to_writer, last_saved.send(attr) }
    else
      raise ObjectNotPersistedError
    end
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