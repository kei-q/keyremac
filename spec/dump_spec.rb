
require 'minitest/autorun'
require 'keyremac/base'
require 'keyremac/dump'

describe 'dump' do
  before do
    @root = Keyremac::Root.new
    @xml = Builder::XmlMarkup.new(indent: 2)
  end

  it 'rootが出力される' do
    expected = <<-EOR
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
  </item>
</root>
    EOR
    @root.dump.must_equal expected
  end

  it '任意のtagを書くことができる' do
    expected = <<-EOT
<item>
</item>
    EOT
    @root.item_ {}.dump(@xml).must_equal expected
  end

  describe 'item' do
    it 'blank' do
      expected = "<item>\n</item>\n"
      @root.item {}.dump(@xml).must_equal expected
    end

    it 'raw' do
      expected = <<-EOT
<item>
  <autogen>__KeyToKey__ KeyCode::J, KeyCode::K</autogen>
</item>
      EOT
      @root.item {
        autogen_ '__KeyToKey__ KeyCode::J, KeyCode::K'
      }.dump(@xml).must_equal expected
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
      expected = <<-EOT
<item>
  <only>TERMINAL</only>
</item>
      EOT
      @root.app('TERMINAL') {}.dump(@xml).must_equal expected
    end
  end

  describe 'to' do
    it 'basic' do
      expected = <<-EOT
<item>
  <autogen>__KeyToKey__ KeyCode::J, KeyCode::K</autogen>
</item>
      EOT
      @root.item { :j .to :k }.dump(@xml).must_equal expected
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
      expected = "KeyCode::J, ModifierFlag::CONTROL_L"
      :j.ctrl.dump(@xml).must_equal expected
    end

    it 'none' do
      expected = "KeyCode::J, ModifierFlag::NONE"
      :j.none.dump(@xml).must_equal expected
    end

    it '複数' do
      expected = "KeyCode::J, ModifierFlag::CONTROL_L | ModifierFlag::COMMAND_L"
      :j.ctrl.cmd.dump(@xml).must_equal expected
    end
  end

  describe 'consumer' do
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