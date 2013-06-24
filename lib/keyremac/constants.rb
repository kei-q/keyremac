module Keyremac
  CONSUMER_KEYS = [
    'BRIGHTNESS_DOWN',
    'BRIGHTNESS_UP',
    'KEYBOARDLIGHT_OFF',
    'KEYBOARDLIGHT_LOW',
    'KEYBOARDLIGHT_HIGH',
    'MUSIC_PREV',
    'MUSIC_PLAY',
    'MUSIC_NEXT',
    'MUSIC_PREV_18',
    'MUSIC_NEXT_17',
    'VOLUME_MUTE',
    'VOLUME_DOWN',
    'VOLUME_UP',
    'EJECT',
    'POWER',
    'NUMLOCK',
    'VIDEO_MIRROR',
  ]

  SYMBOL_TABLE = {
    '`'  => 'BACKQUOTE',
    '\\' => 'BACKSLASH',
    '['  => 'BRACKET_LEFT',
    ']'  => 'BRACKET_RIGHT',
    ','  => 'COMMA',
    '.'  => 'DOT',
    '='  => 'EQUAL',
    '-'  => 'MINUS',
    '\'' => 'QUOTE',
    ';'  => 'SEMICOLON',
    '0'  => 'KEY_0',
    '1'  => 'KEY_1',
    '2'  => 'KEY_2',
    '3'  => 'KEY_3',
    '4'  => 'KEY_4',
    '5'  => 'KEY_5',
    '6'  => 'KEY_6',
    '7'  => 'KEY_7',
    '8'  => 'KEY_8',
    '9'  => 'KEY_9',
  }

  SHIFT_TABLE = Hash[
    %q[!@#$%^&*()_+~QWERTYUIOP{}ASDFGHJKL:"|ZXCVBNM<>?~].each_char.to_a.zip(
    %q(1234567890-=`qwertyuiop[]asdfghjkl;'\zxcvbnm,./`).each_char.to_a
  )]
end
