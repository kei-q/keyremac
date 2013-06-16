
require 'builder'

module Keyremac
  module Container
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
    attr_accessor :children
    def initialize(tag, children = [])
      @tag = tag
      @children = children
    end
  end

  class Item
    include Container

    attr_accessor :children
    def initialize
      @children = []
    end
  end

  class Root
    include Container

    attr_accessor :children
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