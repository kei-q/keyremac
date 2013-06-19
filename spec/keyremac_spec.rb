
require 'minitest/autorun'
require 'keyremac/base'

describe 'root' do
  before do
    @root = Keyremac::Root.new
  end

  it '末尾に_で任意のtagを書くことができる' do
    @root.item_ 'hoge'
    @root.children.length.must_equal 1
  end

  it '任意のtagはblockで入れ子にできる' do
    @root.item_ {
      name_ 'hoge'
    }
    @root.children.length.must_equal 1
  end

  describe 'item' do
    it '' do
      @root.item {}
      @root.children.length.must_equal 1
    end

    it 'raw' do
      @root.item {
        autogen_ '__KeyToKey__ KeyCode::J, KeyCode::K'
      }
      @root.children.length.must_equal 1
    end
  end

  describe 'to' do
    it 'basic' do
      item = @root.item {
        :j .to :k
      }
      item.children.length.must_equal 1
    end

    it 'root直下' do
      :j .to :k
      @root.root_item.children.length.must_equal 1
    end
  end

  describe 'overlaid' do
    it 'basic' do
      item = @root.item {
        :JIS_EISUU .overlaid :COMMAND_L
      }
      item.children.length.must_equal 1
    end

    it 'basic' do
      (:JIS_EISUU .overlaid :COMMAND_L).class.must_equal Keyremac::KeyOverlaidModifier
    end

    it 'keys' do
      autogen = :CONTROL_L .overlaid :CONTROL_L, keys: [:JIS_EISUU, :ESCAPE]
      autogen.class.must_equal Keyremac::KeyOverlaidModifier
    end
  end

  describe 'mods' do
    [:ctrl, :shift, :opt, :cmd, :extra1].each { |mod|
      it mod do
        :j.send(mod).send("#{mod}?").must_equal true
      end
    }
  end

  describe 'key' do
    it '記号を入れると対応するKeyCodeに変換する' do
      ';'.to_key.code.must_equal 'SEMICOLON'
    end

    it 'shiftが必要なkeyは内部で分解する' do
      key = :J.to_key
      key.code.must_equal 'j'
      key.shift?.must_equal true
    end

    it '数値を適切にKeyCodeに変換する' do
      '1'.to_key.code.must_equal 'KEY_1'
    end
  end

  describe 'consumer_key' do
    it 'basic' do
      :MUSIC_PREV.to_key.class.must_equal Keyremac::ConsumerKey
    end
  end

  describe 'autogen' do
    it 'KeyToKey' do
      (:j .to :k).class.must_equal Keyremac::KeyToKey
    end
    it 'KeyToConsumer' do
      (:F7 .to :MUSIC_PREV).class.must_equal Keyremac::KeyToConsumer
    end
  end
end
