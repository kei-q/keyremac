
require 'minitest/autorun'
require 'keyremac/base'

module MiniTest::Assertions
  def assert_add_child(rule)
    expected = 1
    actual = rule.children.length
    assert expected == actual, message { diff expected, actual }
  end
end
Object.infect_an_assertion :assert_add_child, :must_add_child, :unary

module Keyremac
  describe Root do
    let(:root) { Root.new }

    it 'includes any tags' do
      root.item_('hoge')
      root.must_add_child
    end

    it 'includes any tags' do
      root.item_ { name_ 'hoge' }
      root.must_add_child
    end

    it 'includes item' do
      root.item {}
      root.must_add_child
    end

    it 'includes app' do
      root.app('dummy') { }
      root.must_add_child
    end
  end

  describe 'container' do
    let(:root) { Root.new }

    describe 'item' do
      it 'can use item container' do
        root.item { autogen_ '__KeyToKey__ KeyCode::J, KeyCode::K' }
        root.must_add_child
      end

      it 'can use item container with app_only' do
        root.item(app: 'TERMINAL') { }
        root.must_add_child
      end

      it 'can use item container with inputsource_only' do
        root.item(inputsource: 'JAPANESE') { }
        root.must_add_child
      end
    end

    describe 'app' do
      it 'is the same as item container with app_only' do
        container = root.app('dummy') { }
        container.must_be_instance_of Item
      end
    end
  end

  describe 'autogen' do
    let(:root) { Root.new }

    describe 'to' do
      it { root.item { :j .to :k }.must_add_child }
      it { (:j .to :k).must_be_instance_of Autogen::KeyToKey }
      it { (:a .to :b, :c).must_be_instance_of Autogen::KeyToKey }
    end

    describe 'overlaid' do
      it 'generates KeyOverlaidModifier' do
        (:JIS_EISUU .overlaid :COMMAND_L).must_be_instance_of Autogen::KeyOverlaidModifier
      end

      it 'generates KeyOverlaidModifier with keys' do
        autogen = :CONTROL_L .overlaid :CONTROL_L, keys: [:JIS_EISUU, :ESCAPE]
        autogen.class.must_equal Autogen::KeyOverlaidModifier
      end

      it 'has repeat: false by default' do
        autogen = :CONTROL_L .overlaid :CONTROL_L
        autogen.wont_be :repeat?
      end

      it 'enables repeat flag' do
        autogen = :CONTROL_L .overlaid :CONTROL_L, repeat: true
        autogen.must_be :repeat?
      end
    end

    describe 'autogen' do
      it { (:j .to :k).must_be_instance_of Autogen::KeyToKey }
      it { (:F7 .to :MUSIC_PREV).must_be_instance_of Autogen::KeyToConsumer }
    end

    describe 'overlaid' do
      it 'can contain KeyOverlaidModifier' do
        root.item { :JIS_EISUU .overlaid :COMMAND_L }.must_add_child
      end
    end
  end

  describe 'primitive' do
    describe 'key' do
      it { :a.to_key.must_be_kind_of Keyable }
      it { 'a'.to_key.must_be_kind_of Keyable }

      it 'decodes key + shift' do
        key = :J.to_key
        key.code.must_equal 'j'
        key.must_be :shift?
      end

      it 'converts KEY_*' do
        '1'.to_key.code.must_equal 'KEY_1'
      end
    end

    describe 'consumer_key' do
      it { :MUSIC_PREV.to_key.must_be_instance_of ConsumerKey }
    end

    describe 'mods' do
      [:ctrl, :shift, :opt, :cmd, :extra1, :none].each { |mod|
        it "adds #{mod} flag" do
          :j.send(mod).must_be :"#{mod}?"
        end
      }
    end
  end
end