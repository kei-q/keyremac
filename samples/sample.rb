
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
end
# item_ do
#   name_ 'hoge'
#   :c .to :d
# end

# item do
#   :j .to :k
# end