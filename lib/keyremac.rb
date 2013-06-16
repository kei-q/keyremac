require "keyremac/version"
require 'keyremac/base'
require 'keyremac/dump'

module Keyremac
  def self.dump
    puts get_root.dump
  end

  def self.run
    require 'optparse'
    OptionParser.new { |op|
      op.on('--dump', 'dump private.xml') { Keyremac::dump }
      }.parse!(ARGV.dup)
  end
end

include Keyremac::Delegator

at_exit { Keyremac::run }