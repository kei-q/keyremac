require 'awesome_print'
require 'builder'

class Symbol
  def to(to)
    Keyremac::KeyToKey.new self, to
  end
end

module Keyremac
  # @@focus = []
  # def self.focus(container)
  #   @@focus.push container
  #   yield
  #   @@focus.pop
  # end

  # class Tmp
  #   def add(key)
  #   end
  # end

  # def self.focus
  #   Tmp.new
  # end

  class KeyToKey
    def initialize(from, to)
      @from = from
      @to = to
    end
  end

  module Container
    attr_accessor :children
    def add(rule)
      children << rule
    end

    def method_missing(method_name, *args, &block)
      method_name = method_name.to_s
      if method_name[-1] == '_'
        raw = Raw.new method_name.chomp('_')
        if block
          raw.instance_eval(&block)
        else
          raw.children = args[0]
        end
        @children << raw
        raw
      else
        raise NoMethodError, method_name
      end
    end
  end

  class Raw
    include Container
    def initialize(tag, children = [])
      @tag = tag
      @children = children
    end
  end

  class Item
    include Container
    def initialize
      @children = []
    end
  end

  class Root
    include Container
    def initialize
      @root_item = Item.new
      @children = []
    end

    def item(&block)
      item = Item.new
      @children << item
      item.instance_eval(&block)
      item
    end
  end

  module Delegator
    @@root = Root.new

    def get_root
      @@root
    end

    def method_missing(method_name, *args, &block)
      @@root.send(method_name, *args, &block)
    end
  end
end