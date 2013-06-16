
require 'builder'

module Keyremac
  class Raw
    attr_accessor :children
    def initialize(tag, children = [])
      @tag = tag
      @children = children
    end

    def dump(xml)
      if @children.class == String
        xml.tag! @tag, @children
      else
        xml.tag! @tag do
          @children.each { |child|
            child.dump xml
          }
        end
      end
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

  class Root
    attr_reader :children
    def initialize
      @children = []
    end

    def dump
      xml = Builder::XmlMarkup.new(indent: 2)
      xml.instruct!
      xml.root do
        @children.each { |child|
          child.dump(xml)
        }
      end
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

  module Delegator
    @@root = Root.new

    def get_root
      @@root
    end

    def method_missing(*args, &block)
      @@root.method_missing(*args, &block)
    end
  end
end