require_relative 'Persistible_Attr'

class Primitive_Attr < Persistible_Attr
  def save_attr! (instance, attr_persistibles_hash)
    attr_persistibles_hash[name] = instance.send name
  end

  def load_attr! (instance, entry)
    instance.send name, entry[name]
  end

  def delete!
  end
end