
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

  describe 'mods' do
    it 'ctrl' do
      key = :j.ctrl
      key.class.must_equal Keyremac::Key
      key.ctrl?.must_equal true
    end
  end
end
