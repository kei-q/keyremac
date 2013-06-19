require 'awesome_print'
require 'builder'

require 'keyremac/key'

module Keyremac
  # focus
  # ====================================

  @@focus = []

  def self.focus
    @@focus
  end

  def self.get_focus
    @@focus.last
  end
  def self.set_focus(container, &block)
    @@focus.push container
    yield
    @@focus.pop
  end

  # autogen
  # ====================================

  class KeyToKey < Struct.new(:from, :to); end
  class KeyToConsumer < Struct.new(:from, :to); end
  class KeyOverlaidModifier < Struct.new(:key, :mod); end

  # container
  # ====================================

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
          Keyremac.set_focus raw do
            raw.instance_eval(&block)
          end
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

    attr_reader :root_item

    def initialize
      @root_item = Item.new
      Keyremac.focus.clear
      Keyremac.focus << @root_item
      @children = []
    end

    def item(&block)
      item = Item.new
      @children << item
      Keyremac.set_focus item do
        item.instance_eval(&block)
      end
      item
    end
  end

  # delegator
  # ====================================

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