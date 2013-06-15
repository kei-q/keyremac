require "keyremac/version"

require 'builder'

module Keyremac
  class Root
    def dump
      xml = Builder::XmlMarkup.new(indent: 2)
      xml.instruct!
      xml.root do
      end
    end
  end

  @@root = Root.new

  def self.dump
    puts @@root.dump
  end

  def self.run
    require 'optparse'
    OptionParser.new { |op|
      op.on('--dump', 'dump private.xml') { Keyremac::dump }
      }.parse!(ARGV.dup)
  end
end

at_exit { Keyremac::run }