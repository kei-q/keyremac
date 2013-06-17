
require 'keyremac/base'

require 'set'

module Keyremac
  module Keyable
    def ctrl
      self.to_key.add_mod :CONTROL_L
    end
    def ctrl?
      self.to_key.mods.include?(:CONTROL_L)
    end

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

