
require 'keyremac'

item_ do
  name_ 'jis_to_us'
  identifier_ 'private.jis_to_us'
  autogen_ "__SetKeyboardType__ KeyboardType::MACBOOK"
  'JIS_YEN' .to 'BACKQUOTE'
  'JIS_UNDERSCORE' .to 'BACKQUOTE'
end

# semicolonとunderscoreをswap
':' .to ':'
';' .to '_'
'_' .to ';'

:F7 .to :MUSIC_PREV
:F8 .to :MUSIC_PLAY
:F9 .to :MUSIC_NEXT
:F10 .to :VOLUME_MUTE
:F11 .to :VOLUME_DOWN
:F12 .to :VOLUME_UP

# item_ do
#   name_ 'hoge'
#   :c .to :d
# end

# item do
#   :j .to :k
# end