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

    def intersect(other)
      ix0 = [x0, other.x0].max
      ix1 = [x1, other.x1].min
      iy0 = [y0, other.y0].max
      iy1 = [y1, other.y1].min
      
      if ix0 > ix1 || iy0 > iy1
        nil # rectangles are not intersected, in fact
      else
        Rect.new(ix0, iy0, ix1, iy1)
      end
    end
    
    def inspect
      "#<Rect[#{x0},#{y0};#{x1},#{y1}]>"
    end
    
    def to_s
      "#<Rect[#{x0},#{y0};#{x1},#{y1}]>"
    end
  end
end
