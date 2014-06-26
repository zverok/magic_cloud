# encoding: utf-8
#require 'bitarray' - it is memory-effective, yet slower than just plain old Array
$stats = Hash.new{|h,k| h[k] = 0}
  
class MagicCloud
  # Bitmask-based collision board
  class BitCollisionBoard
    class Sprite
      def initialize(width, height)
        @width, @height = width, height
        @data = [0] * height*width # BitArray.new(height*width)
      end

      attr_reader :width, :height, :data
      
      def add_pixel(x, y, px)
        data[width * y + x] = 1 unless px == 0
      end

      def at(x, y)
        #(x >= width || y >= height) and fail("#{x}:#{y} outside #{width} x #{height}")
        
        data[y * width + x] == 1
      end
    end

    def initialize(width, height)
      @width, @height = width, height
      @board = [0] * height*width # BitArray.new(width * height)
      @rects = []
    end
    
    attr_reader :board, :width, :height, :rects

    def sprite(w, h)
      Sprite.new(w, h)
    end

    def at(x, y)
      #(x >= width || y >= height) and fail("#{x}:#{y} outside #{width} x #{height}")
      
      @board[y * width + x] == 1
    end
    
    def set(x, y)
      board[y * width + x] = 1
    end

    def collides?(tag)
      return false if rects.empty? # nothing on board
      
      rect = tag.rect

      if rects.any?{|r| r.criss_cross?(rect)}
        $stats[:criss_cross] += 1 
        # no point to try drawing criss-crossed words
        # even if they will not collide pixel-per-pixel
        return true 
      end

      # then find which of placed sprites rectangles tag intersects
      intersections = rects.map{|r| r.intersect(rect)}
      
      if intersections.compact.empty?
        $stats[:rect_no] += 1 
        puts "#{tag.show} no intersections: #{rect} × #{rects.map(&:inspect).join('; ')}"
        # no need to further check: this tag is not inside any others' rectangle
        return false
      end
      
       # most possible that we are still collide with this word
      if tag.prev_intersected_idx && (prev = intersections[tag.prev_intersected_idx])
        if collides_inside?(tag, prev)
          $stats[:px_prev_yes] += 1
          return true
        end
      end
      
      # only then check points inside intersected rectangles
      intersections.each_with_index do |intersection, idx|
        next unless intersection
        next if idx == tag.prev_intersected_idx # already checked it
        
        if collides_inside?(tag, intersection)
          $stats[:px_yes] += 1
          tag.prev_intersected_idx = idx
          return true
        end
      end
      
      $stats[:px_no] += 1
      return false

      #tag.height.times do |dy|
        #tag.width.times do |dx|
          #if tag.sprite.at(dx, dy) && 
            #(tag.left + dx < width && tag.top + dy < height) && 
            #at(tag.left + dx, tag.top + dy)
            
            #return true 
          #end
        #end
      #end
    end
    
    def collides_inside?(tag, rect)
      (rect.x0...rect.x1).each do |x|
        (rect.y0...rect.y1).each do |y|
          dx = x - tag.left
          dy = y - tag.top
          return true if tag.sprite.at(dx, dy) && at(x, y)
        end
      end
      return false
    end
    
    def add(tag)
      tag.height.times do |dy|
        tag.width.times do |dx|
          set(tag.left+dx, tag.top+dy) if tag.sprite.at(dx, dy) 
        end
      end
      
      rects << tag.rect
    end
  end
end
