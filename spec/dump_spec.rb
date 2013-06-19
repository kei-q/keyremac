
require 'minitest/autorun'
require 'keyremac/base'
require 'keyremac/dump'

describe 'dump' do
  before do
    @root = Keyremac::Root.new
  end

  ROOT = <<-EOR
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
  </item>
%s</root>
  EOR

  it 'rootが出力される' do
    @root.dump.must_equal (ROOT % '')
  end

  it '任意のtagを書くことができる' do
    @root.item_ {}
    expected = ROOT % <<-EOT
  <item>
  </item>
    EOT
    @root.dump.must_equal expected
  end

  describe 'item' do
    before do
      @xml = Builder::XmlMarkup.new(indent: 2)
    end

    it '' do
      @root.item {}
      expected = ROOT % <<-EOT
  <item>
  </item>
      EOT
      @root.dump.must_equal expected
    end

    it 'raw' do
      @root.item {
        autogen_ '__KeyToKey__ KeyCode::J, KeyCode::K'
      }
      expected = ROOT % <<-EOT
  <item>
    <autogen>__KeyToKey__ KeyCode::J, KeyCode::K</autogen>
  </item>
      EOT
      @root.dump.must_equal expected
    end

    it 'app' do
      expected = <<-EOT
<item>
  <only>TERMINAL</only>
</item>
      EOT
      @root.item(app: 'TERMINAL') {}.dump(@xml).must_equal expected
    end

    it 'inputsource' do
      expected = <<-EOT
<item>
  <inputsource_only>JAPANESE</inputsource_only>
</item>
      EOT
      @root.item(inputsource: 'JAPANESE') {}.dump(@xml).must_equal expected
    end
  end

  describe 'app' do
    it 'raw' do
      @root.app('TERMINAL') {}
      expected = ROOT % <<-EOT
  <item>
    <only>TERMINAL</only>
  </item>
      EOT
      @root.dump.must_equal expected
    end
  end

  describe 'to' do
    before do
      @xml = Builder::XmlMarkup.new(indent: 2)
    end
    it 'basic' do
      item = @root.item {
        :j .to :k
      }
      expected = ROOT % <<-EOT
  <item>
    <autogen>__KeyToKey__ KeyCode::J, KeyCode::K</autogen>
  </item>
      EOT
      @root.dump.must_equal expected
    end

    it '複数' do
      expected = "<autogen>__KeyToKey__ KeyCode::J, KeyCode::K, KeyCode::L</autogen>\n"
      (:j .to :k, :l).dump(@xml).must_equal expected
    end
  end

  ROOT2 = <<-EOR
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
%s  </item>
</root>
  EOR

  describe 'root直下' do
    it 'root直下' do
      :j .to :k
      expected = ROOT2 % <<-EOT
    <autogen>__KeyToKey__ KeyCode::J, KeyCode::K</autogen>
      EOT
      @root.dump.must_equal expected
    end
  end

  describe 'mods' do
    it 'ctrl' do
      :j.ctrl .to :k
      expected = ROOT2 % <<-EOT
    <autogen>__KeyToKey__ KeyCode::J, ModifierFlag::CONTROL_L, KeyCode::K</autogen>
      EOT
      @root.dump.must_equal expected
    end
  end

  describe 'consumer' do
    before do
      @xml = Builder::XmlMarkup.new(indent: 2)
    end
    it 'consumer_key' do
      expected = "ConsumerKeyCode::MUSIC_PREV"
      :MUSIC_PREV.to_key.dump(@xml).must_equal expected
    end
    it 'key_to_consumer' do
      expected = "<autogen>__KeyToConsumer__ KeyCode::F7, ConsumerKeyCode::MUSIC_PREV</autogen>\n"
      (:F7.to:MUSIC_PREV).dump(@xml).must_equal expected
    end
  end

  describe 'key_overlaid_modifier' do
    before do
      @xml = Builder::XmlMarkup.new(indent: 2)
    end
    it 'basic' do
      expected = "<autogen>__KeyOverlaidModifier__ KeyCode::JIS_EISUU, KeyCode::COMMAND_L, KeyCode::JIS_EISUU</autogen>\n"
      (:JIS_EISUU.overlaid:COMMAND_L).dump(@xml).must_equal expected
    end
    it 'keys' do
      expected = "<autogen>__KeyOverlaidModifier__ KeyCode::CONTROL_L, KeyCode::CONTROL_L, KeyCode::JIS_EISUU, KeyCode::ESCAPE</autogen>\n"
      autogen = :CONTROL_L .overlaid :CONTROL_L, keys: [:JIS_EISUU, :ESCAPE]
      autogen.dump(@xml).must_equal expected
    end

    it 'repeat' do
      expected = "<autogen>__KeyOverlaidModifierWithRepeat__ KeyCode::SPACE, KeyCode::SHIFT_L, KeyCode::SPACE</autogen>\n"
      autogen = :SPACE .overlaid :SHIFT_L, repeat: true
      autogen.dump(@xml).must_equal expected
    end
  end
end