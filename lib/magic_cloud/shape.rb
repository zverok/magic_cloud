# encoding: utf-8
module MagicCloud
  class Shape
    attr_accessor :sprite, :x, :y
    
    def width
      sprite.width
    end

    def height
      sprite.height
    end
    
    def left; x end
    
    def right; x+width end
    
    def top; y end
    
    def bottom; y+height end
    
    def rect
      Rect.new(x,y,x+width,y+height)
    end
    
    # returns rect
    def draw(canvas)
      fail NotImplementedError
    end
  end
end
