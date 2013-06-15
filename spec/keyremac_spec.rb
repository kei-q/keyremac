
require 'minitest/autorun'
require 'keyremac'

describe 'root' do
  it 'rootが出力される' do
    root = Keyremac::Root.new
    expected = <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<root>
</root>
EOT
    root.dump.must_equal expected
  end
end
