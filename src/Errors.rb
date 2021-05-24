class ObjectNotPersistedError < StandardError
  def initialize(msg = "No se puede enviar el mensaje refresh! a una instancia que no fue persistida")
    super
  end
end

class NoReaderError < StandardError
  def initialize(msg = "No se puede realizar el filtrado de un metodo que no sea getter")
    super
  end
end