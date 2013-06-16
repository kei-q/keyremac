module Keyremac
  class Raw
    def dump(xml)
      if @children.class == String
        xml.tag! @tag, @children
      else
        xml.tag! @tag do
          @children.each { |child|
            child.dump xml
          }
        end
      end
    end
  end

  class Item
    def dump(xml)
      xml.item do
        @children.each { |child|
          child.dump xml
        }
      end
    end
  end

  class Root
    def dump
      xml = Builder::XmlMarkup.new(indent: 2)
      xml.instruct!
      xml.root do
        @children.each { |child|
          child.dump(xml)
        }
      end
    end
  end
end