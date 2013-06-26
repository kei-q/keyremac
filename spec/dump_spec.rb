
require 'minitest/autorun'
require 'keyremac/dump'

module MiniTest::Assertions
  def assert_xml(expected, rule)
    xml = Builder::XmlMarkup.new(indent: 2)
    actual = rule.dump(xml)
    assert actual == expected, message { diff expected, actual }
  end

  def assert_item(expected, rule)
    expected = <<-EOI
<item>
  <name>a</name>
  <identifier>private.a</identifier>
  #{expected}
</item>
    EOI
    xml = Builder::XmlMarkup.new(indent: 2)
    actual = rule.dump(xml)
    assert actual == expected, message { diff expected, actual }
  end

  def assert_autogen(expected, rule)
    xml = Builder::XmlMarkup.new(indent: 2)
    actual = rule.dump(xml)
    assert_match("autogen", actual)
    assert_match(expected, actual)
  end

  def assert_tag(expected, rule)
    xml = Builder::XmlMarkup.new(indent: 2)
    actual = rule.dump(xml)
    assert_match(expected, actual)
  end
end
Object.infect_an_assertion :assert_xml, :must_be_xml
Object.infect_an_assertion :assert_item, :must_be_item
Object.infect_an_assertion :assert_autogen, :must_be_autogen
Object.infect_an_assertion :assert_tag, :must_contain_tag

describe 'root' do
  let(:root) { Keyremac::Root.new }

  it 'generates root tag' do
    expected = <<-EOR
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
    <name>root_item</name>
    <identifier>private.root_item</identifier>
  </item>
</root>
    EOR
    root.must_be_xml expected
  end
end

describe 'raw' do
  let(:root) { Keyremac::Root.new }

  it 'can write any tags' do
    root.hoge_ {}.must_contain_tag "hoge"
    root.fuga_("").must_contain_tag "fuga"
  end
end

describe Keyremac::Key do
  describe '#to' do
    it { (:j .to :k).must_be_autogen "KeyToKey" }
    it { (:j .to :k, :l).must_be_autogen "KeyToKey" }
    it { (:F7.to:MUSIC_PREV).must_be_autogen "KeyToConsumer" }
  end
end

describe 'root' do
  before do
    @root = Keyremac::Root.new
  end

  ROOT2 = <<-EOR
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
    <name>root_item</name>
    <identifier>private.root_item</identifier>
    %s
  </item>
</root>
  EOR

  it 'can write toplevel key definition' do
    :j .to :k
    expected = ROOT2 % "<autogen>__KeyToKey__ KeyCode::J, KeyCode::K</autogen>"
    @root.must_be_xml expected
  end
end

describe 'dump' do
  before do
    @root = Keyremac::Root.new
    Keyremac::Item.reset_identifier
  end

  describe 'item' do
    it 'generates item tag' do
      contents = '__KeyToKey__ KeyCode::J, KeyCode::K'
      @root.item { autogen_ contents }.must_be_item "<autogen>#{contents}</autogen>"
    end

    it 'generates item tag with only tag' do
      @root.item(app: 'TERMINAL') {}.must_be_item "<only>TERMINAL</only>"
    end

    it 'generates item tag with inputsource_only tag' do
      @root.item(inputsource: 'JAPANESE') {}.must_be_item "<inputsource_only>JAPANESE</inputsource_only>"
    end

    it 'generates item tag with only tag' do
      @root.app('TERMINAL') {}.must_be_item "<only>TERMINAL</only>"
    end
  end

  describe 'mods' do
    it 'trails mod key' do
      :j.ctrl.must_be_xml "KeyCode::J, VK_CONTROL"
    end

    it 'trails none flag' do
      :j.none.must_be_xml "KeyCode::J, ModifierFlag::NONE"
    end

    it 'trails mod keys' do
      :j.ctrl.cmd.must_be_xml "KeyCode::J, VK_CONTROL | VK_COMMAND"
    end
  end

  describe 'key_overlaid_modifier' do
    it 'generates KeyOverlaidModifier' do
      expected = "__KeyOverlaidModifier__ KeyCode::JIS_EISUU, KeyCode::COMMAND_L, KeyCode::JIS_EISUU"
      (:JIS_EISUU.overlaid:COMMAND_L).must_be_autogen expected
    end

    it 'generates KeyOverlaidModifier with keys' do
      expected = "__KeyOverlaidModifier__ KeyCode::CONTROL_L, KeyCode::CONTROL_L, KeyCode::JIS_EISUU, KeyCode::ESCAPE"
      autogen = :CONTROL_L .overlaid :CONTROL_L, keys: [:JIS_EISUU, :ESCAPE]
      autogen.must_be_autogen expected
    end

    it 'generates KeyOverlaidModifierWithRepeat' do
      expected = "__KeyOverlaidModifierWithRepeat__ KeyCode::SPACE, KeyCode::SHIFT_L, KeyCode::SPACE"
      autogen = :SPACE .overlaid :SHIFT_L, repeat: true
      autogen.must_be_autogen expected
    end
  end
end