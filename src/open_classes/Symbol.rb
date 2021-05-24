class Symbol
  def to_writer
    "#{self}=".to_sym
  end
end