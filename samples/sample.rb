
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

:F7  .to :MUSIC_PREV
:F8  .to :MUSIC_PLAY
:F9  .to :MUSIC_NEXT
:F10 .to :VOLUME_MUTE
:F11 .to :VOLUME_DOWN
:F12 .to :VOLUME_UP

:JIS_EISUU .overlaid :COMMAND_L
:CONTROL_L .overlaid :CONTROL_L, keys: [:JIS_EISUU, :ESCAPE]
:SPACE     .overlaid :SHIFT_L, repeat: true

:m.cmd     .to :VK_NONE   # disable_minimize
:j.ctrl    .to :JIS_KANA # "Google IME"
:JIS_KANA  .to :RETURN
:COMMAND_L .to :OPTION_L

# extra1
:SHIFT_L.cmd      .to :SHIFT_L.cmd
:SHIFT_L.opt      .to :SHIFT_L.opt
:SHIFT_L.ctrl     .to :SHIFT_L.ctrl
:CONTROL_L.extra1 .to :CONTROL_L.shift
:SHIFT_L          .to :VK_MODIFIER_EXTRA1

app 'TERMINAL' do
  "pnco".chars { |c| c.extra1 .to :JIS_EISUU, :t.ctrl, c }
  "jkl" .chars { |c| c.extra1 .to :JIS_EISUU, :t.ctrl, c }
  "du"  .chars { |c| c.extra1 .to :t.ctrl, '['.ctrl, c.ctrl }
end

appdef_ do
  appname_ "SUBLIME"
  equal_ "com.sublimetext.3"
  equal_ "com.sublimetext.2"
end

['SUBLIME', 'GOOGLE_CHROME'].each { |app_name|
  app app_name do
    :p.extra1 .to :JIS_EISUU, '['.cmd.shift
    :n.extra1 .to :JIS_EISUU, ']'.cmd.shift
  end
}

app 'SUBLIME', inputsource: 'JAPANESE' do
  :TAB .to :i.ctrl
end

# item_ 'all_up_down' do
#   :p.ctrl.none .to :CURSOR_UP
#   :n.ctrl.none .to :CURSOR_DOWN
# end
