
require 'keyremac/base'
require 'keyremac/constants'

require 'set'

module Keyremac
  module Keyable
    {
      ctrl:   :VK_CONTROL,
      shift:  :VK_SHIFT,
      opt:    :VK_OPTION,
      cmd:    :VK_COMMAND,
      extra1: :EXTRA1,
      none:   :NONE,
    }.each { |k,v|
      define_method(k, -> { self.to_key.add_mod v })
      define_method("#{k}?", -> { self.to_key.mods.include? v })
    }

    # @param [Array<Keyable>] keys
    # @return [KeyToKey]
    # @return [KeyToConsumer]
    def to(*keys)
      key = keys.first.to_key
      autogen = if key.consumer_key?
        Keyremac::KeyToConsumer.new self.to_key, key
      else
        Keyremac::KeyToKey.new self.to_key, keys.map(&:to_key)
      end
      Keyremac.get_focus.add autogen
      autogen
    end

    # @param [Keyable] mod
    # @options [Keyable] mod
    # @return [KeyToOverlaidModifier]
    def overlaid(mod, keys: [], repeat: false)
      autogen = Keyremac::KeyOverlaidModifier.new self.to_key, mod.to_key, keys: keys.map(&:to_key), repeat: repeat
      Keyremac.get_focus.add autogen
      autogen
    end

    def consumer_key?
      false
    end

    def to_key
      if Keyremac::CONSUMER_KEYS.include?(self.to_s)
        Keyremac::ConsumerKey.new self.to_s
      else
        Keyremac::Key.new self.to_s
      end
    end
  end

  class ConsumerKey < Struct.new(:code)
    include Keyable
    def consumer_key?; true end
    def to_key; self end
  end

  class Key
    include Keyable
    attr_reader :code, :mods

    def to_key
      self
    end

    def initialize(name)
      @mods = Set.new

      if key = SHIFT_TABLE[name]
        @code = SYMBOL_TABLE[key] || key
        self.shift
      else
        @code = SYMBOL_TABLE[name] || name
      end
    end

    def add_mod(mod)
      @mods.add mod
      self
    end
  end
end

class Symbol; include Keyremac::Keyable; end
class String; include Keyremac::Keyable; end
