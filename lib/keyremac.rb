require "keyremac/version"
require 'keyremac/base'
require 'keyremac/dump'

require 'rexml/document'

module Keyremac
  def self.dump
    puts get_root.dump
  end

  def self.collect_identifiers
    xml = get_root.dump
    doc = REXML::Document.new(xml)

    result = []
    doc.elements.each('//identifier') {|e|
      result << e.text
    }
    result
  end

  CLI_PATH = '/Applications/Karabiner.app/Contents/Library/bin/karabiner'
  DEFAULT_SETTINGS_PATH = '~/Library/Application Support/Karabiner/private.xml'

  def self.reload
    File.write File.expand_path(DEFAULT_SETTINGS_PATH), get_root.dump
    `#{CLI_PATH} reloadxml`
    self.collect_identifiers.each { |id|
     `#{CLI_PATH} enable #{id}`
    }
  end

  def self.run
    require 'optparse'
    OptionParser.new { |op|
      op.on('--dump', 'dump private.xml') { Keyremac::dump }
      op.on('--reload', 'reload private.xml') { Keyremac::reload }
      op.on('--ids', 'collect identifiers') { puts Keyremac::collect_identifiers }
      }.parse!(ARGV.dup)
  end
end

include Keyremac::Delegator

at_exit { Keyremac::run }