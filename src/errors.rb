class ObjectNotPersistedError < StandardError
  def initialize(msg = "No se puede enviar el mensaje refresh! a una instancia que no fue persistida")
    super
  end
end