
require 'keyremac'



:a .to :b
:a.ctrl .to :b

item_ do
  name_ 'test'
  identifier_ 'private.hoge'
end

item_ do
  name_ 'hoge'
  :c .to :d
end

item do
  :j .to :k
end