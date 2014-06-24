# encoding: utf-8
class MagicCloud
  class Rect < Struct.new(:x0, :y0, :x1, :y1)
    def collide?(other)
      x1 > other.x0 &&
          x0 < other.x1 &&
          y1 > other.y0 && 
          y0 < other.y1
    end
    
    def adjust!(other)
      self.x0 = other.x0 if other.x0 < x0
      self.y0 = other.y0 if other.y0 < y0
      self.x1 = other.x1 if other.x1 > x1
      self.y1 = other.y1 if other.y1 > y1
    end
    
    def adjust(other)
      dup.tap{|d| d.adjust!(other)}
    end
  end
end
