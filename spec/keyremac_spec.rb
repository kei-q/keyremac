
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
end

describe 'dump' do
  before do
    @root = Keyremac::Root.new
  end

  it 'rootが出力される' do
    expected = <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<root>
</root>
EOT
    @root.dump.must_equal expected
  end

  it '任意のtagを書くことができる' do
    @root.item_ {}
    expected = <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
  </item>
</root>
EOT
    @root.dump.must_equal expected
  end

  describe 'item' do
    it '' do
      @root.item {}
    expected = <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
  </item>
</root>
EOT
      @root.dump.must_equal expected
    end

    it 'raw' do
      @root.item {
        autogen_ '__KeyToKey__ KeyCode::J, KeyCode::K'
      }
    expected = <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
    <autogen>__KeyToKey__ KeyCode::J, KeyCode::K</autogen>
  </item>
</root>
EOT
      @root.dump.must_equal expected
    end
  end
end