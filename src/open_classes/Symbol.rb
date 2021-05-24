class Symbol
  def to_writer
    "#{self}=".to_sym
  end

  def to_attr
    "@#{self}"
  end
end