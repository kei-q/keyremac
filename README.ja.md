# Keyremac

KeyRemap4MacBookを簡単に設定するためのDSLを提供します。

## 必要なもの

KeyRemap4MacBook v7.0.0 以上
ruby v2.0.0 以上

## Installation

    $ gem install keyremac --source http://github.com/keqh/keyremac/raw/master

## Example

### 設定の記述

以下の様なsourceを用意します。ここでは仮に`private.rb`とします。

    require 'keyremac'
    :SPACE .to :TAB

SymbolはKeyRemap4MacBookの`KeyCode`になります。
調べるにはKeyRemap4MacBookの`Launch EventViewer`を使います。

`.to`は`KeyToKey`を生成するためのmethodです。
`KeyToKey`は指定したキーを別のキーに変換します。
上記の例では、`SPACE`を押すと`TAB`を押したことになる設定を記述しています。

### 設定の反映

`--reload`をつけて実行すると、private.xmlの生成・配置とreloadが行われます。
**すでにprivate.xmlが存在していても予告なしに上書くので、あらかじめbackupをお願いします。**
変換後、正しい設定ならなにも出力しません。
もしKeyRemap4MacBookが受け付けない設定が含まれているときはdialogが表示されます。

    ruby private.rb --reload

### private.xmlの確認

どのようなprivate.xmlが出力されるか確認したいときは`--dump`を使用します。

    ruby private.rb --dump

上記の設定を出力すると、以下のようなxmlが生成されます。

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

## documents

TODO: rdoc整備したらリンク載せる

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
