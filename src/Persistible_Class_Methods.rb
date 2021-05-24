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
    make_find_by! persistible_attr
  end

  def make_find_by! (attr)
    cls = self.class
    cls.define_method ("find_by_#{attr}").to_sym do | value |
      puts value
      # cls.all_instances.filter { |instance| (instance.send attr) == value }
    end
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
end