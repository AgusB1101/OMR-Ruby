require 'tadb'

class Table
  attr_reader :table, :table_class

  def initialize (cls)
    @table = TADB::DB.table(cls.name)
    @table_class = cls
  end

  def self.clear_all!
    TADB::DB.clear_all
  end

  def insert_instance (instance)
    attr_persistibles = {}

    instance.class.all_simple_attr_persistibles.each do |_, attr|
      attr.save_attr! instance, attr_persistibles
    end

    id = table.insert attr_persistibles
    instance.instance_variable_set :@id, id

    id
  end

  def insert (instance)
    insert_instance instance
  end

  def read (id)
    table_class.find_by_id(id).first
  end

  def delete! (id)
    table.delete id
  end
end