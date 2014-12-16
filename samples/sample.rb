lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'keyremac'

item_ do
  name_ 'jis_to_us'
  identifier_ 'private.jis_to_us'
  autogen_ "__SetKeyboardType__ KeyboardType::MACBOOK"
  :JIS_YEN .to :BACKQUOTE
  :JIS_UNDERSCORE .to :BACKQUOTE
end

# semicolonとunderscoreをswap
':' .to ':'
';' .to '_'
'_' .to ';'

# 外部キーボード用
:F7  .to :MUSIC_PREV
:F8  .to :MUSIC_PLAY
:F9  .to :MUSIC_NEXT
:F10 .to :VOLUME_MUTE
:F11 .to :VOLUME_DOWN
:F12 .to :VOLUME_UP

:JIS_EISUU .overlaid :COMMAND_L
:CONTROL_L .overlaid :CONTROL_L, keys: [:JIS_EISUU, :ESCAPE]
:CONTROL_R .overlaid :CONTROL_L, keys: [:JIS_EISUU, :ESCAPE]
:SPACE     .overlaid :SHIFT_L, repeat: true

:m.cmd     .to :VK_NONE   # disable_minimize
:j.ctrl.none .to :JIS_KANA # "Google IME"
:JIS_KANA  .to :RETURN
:COMMAND_L .to :OPTION_L
# :COMMAND_L .overlaid :OPTION_L, keys: [:JIS_KANA]
:TAB.opt .to :TAB.cmd

# GTDtool用
:COMMAND_R .to :COMMAND_R.ctrl.shift

# extra1
:SHIFT_L.cmd      .to :SHIFT_L.cmd
:SHIFT_L.opt      .to :SHIFT_L.opt
:SHIFT_L.ctrl     .to :SHIFT_L.ctrl
:CONTROL_L.extra1 .to :CONTROL_L.shift
:SHIFT_L          .to :VK_MODIFIER_EXTRA1

# ctrl-npを強制的に↑↓に
:p.ctrl.none .to :CURSOR_UP
:n.ctrl.none .to :CURSOR_DOWN
:b.ctrl.none .to :CURSOR_LEFT
:f.ctrl.none .to :CURSOR_RIGHT

# ctrl-hはいつどんなときでもbackspace
:h.ctrl.none .to :DELETE


app 'TERMINAL' do
  "pn".chars { |c| c.extra1 .to :JIS_EISUU, :t.ctrl, c }
  "co".chars { |c| c.extra1 .to :JIS_EISUU, :t.ctrl, c }
  "jkl" .chars { |c| c.extra1 .to :JIS_EISUU, :t.ctrl, c }
  "du"  .chars { |c| c.extra1 .to :t.ctrl, '['.ctrl, c.ctrl }
end

app "SUBLIMETEXT" do
  ".".extra1 .to *("->".chars)
  ",".extra1 .to *("<-".chars)
  "_".extra1 .to *("::".chars)
end

app 'SUBLIMETEXT', inputsource: 'JAPANESE' do
  :TAB .to :i.ctrl
end

item_ do
  name_ 'focus_tab'
  identifier_ 'private.focus_tab'
  not_ 'TERMINAL'
  # タブの移動
  :p.extra1 .to :JIS_EISUU, '['.cmd.shift
  :n.extra1 .to :JIS_EISUU, ']'.cmd.shift
end

app 'XCODE' do
  :s.opt .to :JIS_EISUU, :o.cmd.shift, '.', 's', 't', 'o', 'r', 'y', :RETURN
end
