module PersistibleClass
  def has_one (cls, hash)
    self.attr_accessor hash[:named]
  end
end