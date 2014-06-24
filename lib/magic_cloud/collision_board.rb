# encoding: utf-8
require 'bitarray'
  
class MagicCloud
  # Bitmask-based collision board
  class BitCollisionBoard
    class Sprite
      def initialize(width, height)
        @width, @height = width, height
        @data = BitArray.new(height*width)
      end

      attr_reader :width, :height, :data
      
      def add_pixel(x, y, px)
        val = px.zero? ? 0 : 1
        idx = width * y + x
        
        data[idx] |= val
      end

      def at(x, y)
        (x >= width || y >= height) and fail("#{x}:#{y} outside #{width} x #{height}")
        
        data[y * width + x]
      end
    end

    def initialize(width, height)
      @width, @height = width, height
      @board = BitArray.new(width * height)
    end
    
    attr_reader :board, :width, :height

    def sprite(w, h)
      Sprite.new(w, h)
    end

    def at(x, y)
      (x >= width || y >= height) and fail("#{x}:#{y} outside #{width} x #{height}")
      
      board[y * width + x]
    end
    
    def put(x, y, val)
      board[y * width + x] = val
    end

    def collides?(tag)
      tag.height.times do |dy|
        tag.width.times do |dx|
          px = tag.sprite.at(dx, dy)
          if !px.zero? && tag.left + dx < width && tag.top + dy < height && !at(tag.left + dx, tag.top + dy).zero?
            return true 
          end
        end
      end
      
      return false
    end
    
    def add(tag)
      tag.height.times do |dy|
        tag.width.times do |dx|
          px = tag.sprite.at(dx, dy)
          if !px.zero? && tag.left + dx < width && tag.top + dy < height
            put(tag.left+dx, tag.top+dy, px) 
          end
        end
      end
    end
  end
end
