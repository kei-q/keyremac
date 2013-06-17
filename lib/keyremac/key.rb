
require 'keyremac/base'

require 'set'

module Keyremac
  module Keyable
    {
      ctrl:   :CONTROL_L,
      shift:  :SHIFT_L,
      opt:    :OPTION_L,
      cmd:    :COMMAND_L,
      extra1: :EXTRA1,
    }.each { |k,v|
      define_method(k, -> { self.to_key.add_mod v })
      define_method("#{k}?", -> { self.to_key.mods.include? v })
    }

    def to(to)
      key = Keyremac::KeyToKey.new self.to_key, to.to_key
      Keyremac.get_focus.add key
      key
    end
  end

  class Key
    include Keyable

    attr_reader :mods

    def to_key
      self
    end

    def initialize(name)
      @name = name
      @mods = Set.new
    end

    def add_mod(mod)
      @mods.add mod
      self
    end
  end
end

class Symbol
  include Keyremac::Keyable
  def to_key
    Keyremac::Key.new self.to_s
  end
end

