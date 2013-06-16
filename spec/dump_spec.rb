
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
  end

  describe 'to' do
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
  end
end