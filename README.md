# Keyremac

Keyremac is KeyRemap4MacBook settings generator.

## dependency

- KeyRemap4MacBook v7.0.0+
    - https://pqrs.org/macosx/keyremap4macbook/
- ruby v2.0.0+

## Installation

    $ gem install keyremac

## Getting Started

```bash
$ cat > private.rb
require 'keyremac'
:SPACE .to :TAB

$ ruby private.rb --dump
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <item>
    <name>root_item</name>
    <identifier>private.root_item</identifier>
    <autogen>__KeyToKey__ KeyCode::SPACE, KeyCode::TAB</autogen>
    <autogen>__KeyToKey__ KeyCode::TAB, KeyCode::SPACE</autogen>
    <autogen>__KeyToKey__ KeyCode::COMMAND_R, KeyCode::ESCAPE</autogen>
  </item>
</root>

$ ruby private.rb --reload
```

## Examples

### simple KeyToKey

```rb
:SPACE .to :TAB
```

### mods (cmd, ctrl, opt, shift, none)

```rb
:m.cmd .to :VK_NONE
:j.ctrl .to :JIS_KANA
```

### key to keys

```rb
:n.ctrl.cmd .to :JIS_EISUU, '['.cmd.shift
:p.ctrl.cmd .to :JIS_EISUU, ']'.cmd.shift
```

### app_only

```rb
app "CHROME" do
  :m.cmd.none .to :VK_NONE
end

# or

item app: "CHORME" do
  ...
end
```

### inputsource_only

```
item inputsource: "JAPANESE" do
  :l .to :JIS_EISUU
end
```

### raw

```
item_ do
  name_ 'jis_to_us'
  identifier_ 'private.jis_to_us'
  autogen_ "__SetKeyboardType__ KeyboardType::MACBOOK"
  :JIS_YEN .to :BACKQUOTE
  :JIS_UNDERSCORE .to :BACKQUOTE
end
```

- more examples: https://github.com/keqh/keyremac/tree/master/samples
- and specs: https://github.com/keqh/keyremac/tree/master/spec

