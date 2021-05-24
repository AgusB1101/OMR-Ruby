require_relative 'tables/Table'
require_relative 'persistible_attrs/Primitive_Attr'
require_relative 'persistible_attrs/Complex_Attr'
require_relative 'Boolean'

module PersistibleClass

  attr_reader :my_table

  def self.extended (base)
    base._create_table
    base._init_persistible_attrs
    base.make_find_by! :id
    puts base.instance_methods false
  end

  def has_one (cls, info_attr)
    persistible_attr = info_attr[:named]
    _create_accessor persistible_attr
    if _is_primitive? cls
      attr = Primitive_Attr.new(cls, info_attr)
    else
      attr = Complex_Attr.new(cls, info_attr)
    end

    attr_persistibles.merge! attr.name => attr
    # make_find_by! persistible_attr
  end

  def make_find_by! (attr)
    self.class.define_method ("find_by_#{attr}").to_sym do | value |
      all_instances.filter { |instance| (instance.instance_variable_get attr.to_attr) == value}
    end
  end

  def get_object (entry)
    instance = self.new
    entry.each_pair { |key, value| instance.instance_variable_set(key.to_attr, value)}
    instance
  end

  def all_instances
    entries = self.my_table.table.entries
    entries.map { |entry| self.get_object entry }
  end

  def all_simple_attr_persistibles
    attr_persistibles.filter do |_, attr|
      attr.is_a? Primitive_Attr or attr.is_a? Complex_Attr
    end
  end

  def attr_persistibles
    @attr_persistibles
  end

  def _is_primitive? (cls)
    cls.eql? String or cls.ancestors.include? Boolean or cls.ancestors.include? Numeric
  end

  def _create_accessor (attr)
    self.attr_accessor attr
  end

  def _create_table
    @my_table = Table.new(self)
  end

  def _init_persistible_attrs
    @attr_persistibles = {}
    @attr_persistibles[:id] = Primitive_Attr.new(String, { named: :id })
  end

  def find_by (attr, args)
    unless self.instance_method(attr).arity.eql? 0
      raise NoReaderError
    end
    unless args.length.eql? 1
      raise ArgumentError.new("wrong number of arguments (given #{args.length}, expected 1)")
    end

    self.all_instances.filter { |instance| instance.send(attr) == args.first }
  end

  def method_missing (selector, *args)
    attr = selector.to_s.sub("find_by_", "").to_sym

    unless selector.to_s.start_with? "find_by_" and (instance_methods(false).append(:id)).include? attr
      raise NoMethodError.new(selector.to_s)
    end
    self.find_by(attr, args)
  end
end