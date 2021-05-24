require_relative '../open_classes/Symbol'

class Persistible_Attr
  attr_reader :name, :cls

  def initialize (cls, info_attr)
    @cls         = cls
    @name       = info_attr[:named]
    @default_val = info_attr[:default]
  end

  def set_default_val (instance)
    actual_val = actual_val instance
    instance.send name.to_writer, @default_val if actual_val.nil?
  end

  def actual_val (instance)
    instance.send name
  end
end