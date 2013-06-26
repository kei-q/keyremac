require 'awesome_print'
require 'builder'

require 'keyremac/key'

module Keyremac
  module Focus
    @@focus = []

    def self.add(rule)
      @@focus.last.add rule
    end

    def self.focus
      @@focus
    end

    def self.set_focus(container, &block)
      @@focus.push container
      yield
      @@focus.pop
    end
  end

  module Autogen
    class KeyToKey < Struct.new(:from, :to); end
    class KeyToConsumer < Struct.new(:from, :to); end
    class KeyOverlaidModifier
      attr_reader :key, :mod, :keys, :repeat
      def initialize(key, mod, keys: [], repeat: false)
        @key = key
        @mod = mod
        @keys = keys == [] ? [key] : keys
        @repeat = repeat
      end

      def repeat?
        @repeat
      end
    end
  end

  # @group container
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
          Keyremac::Focus.set_focus raw do
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

    @@identifier = 'a'
    def self.identifier
      @@identifier
    end
    def self.reset_identifier
      @@identifier = 'a'
    end

    def initialize(name = nil)
      @children = []
      @name = name || @@identifier
      @@identifier = @@identifier.succ
    end
  end

  class Root
    include Container

    attr_reader :root_item

    def initialize
      @root_item = Item.new 'root_item'
      Keyremac::Focus.focus.clear
      Keyremac::Focus.focus << @root_item
      @children = []
    end

    # @param [String] app only tag
    # @param [String] inputsource inputsource_only tag
    # yield [] children
    # @return [Item]
    def item(app: nil, inputsource: nil, &block)
      Item.new.tap { |item|
        item.only_ app if app
        item.inputsource_only_ inputsource if inputsource
        @children << item
        Keyremac::Focus.set_focus item do
          item.instance_eval(&block)
        end
      }
    end

    # @param [String] only
    # @option options same as item method
    # @return [Item]
    def app(only, **options, &block)
      options[:app] = only
      item(**options, &block)
    end
  end

  # delegator
  # ====================================

  module Delegator
    @@root = Root.new

    def get_root
      @@root
    end

    def method_missing(*args, &block)
      @@root.send(*args, &block)
    end
  end
end