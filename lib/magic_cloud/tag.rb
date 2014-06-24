# encoding: utf-8
class MagicCloud
  class Tag
    def initialize(text, size, cloud)
      @text, @size, @cloud = text.to_s, size, cloud

      # first, place it randomly
      @x = (cloud.width * (rand + 0.5)).to_i >> 1
      @y = (cloud.height * (rand + 0.5)).to_i >> 1
      
      @top_offset = 0
      @bottom_offset = 0
      @left_offset = 0
      @right_offset = 0
      
      #@rotate = (((rand * 6) - 3) * 30).round
      @rotate = (rand * 2).to_i * 90
    end
    
    attr_reader :text, :size, :cloud
    attr_reader :rotate

    attr_accessor :x, :y
    attr_accessor :xoff, :yoff
    attr_accessor :top_offset, :bottom_offset, :left_offset, :right_offset
    attr_accessor :width, :height
    
    attr_accessor :sprite
    
    def find_place
      start_x = x
      start_y = y
      
      max_delta = Math.sqrt(cloud.width**2 + cloud.height**2)
      dt = rand < 0.5 ? 1 : -1 # direction of spiral, I assume
      t = -dt

      # looking for the place for this word, moving in spirals from center 
      while true
        t += dt
        dx, dy = archimedean_spiral(t)
        
        break if [dx, dy].map(&:abs).min > max_delta # no chances to find place :(

        self.x = start_x + dx;
        self.y = start_y + dy;

        #p ['try', show, t, x, y]

        # out of cloud rectangle, let's try another
        #next if left < 0 || 
            #top < 0 ||
            #right > cloud.width || 
            #bottom > cloud.height 
            
        # d3.layout.cloud: TODO only check for collisions within current bounds.
        #if !cloud.bounds || (!collide? && rect.collide?(cloud.bounds))
        if !cloud.board.collides?(self)
          #puts "#{show} placed after step #{t}: #{start_x}:#{start_y} -> #{dx}:#{dy}"
          cloud.board.add(self)
          
          return true
        end
      end
      
      false
    end
    
    def dump_sprite(filename)
        w32 = width >> 5
        sprite.size == height*w32 or fail("Sprite size #{sprite.size}, expected #{height*w32}")
        
        dump = (0...height).map{|row|
            (0...w32).map{|col|
                px = sprite[row*w32+col]
                px.zero? ? ' ' : '.'
            }.join
        }.join("\n")
        File.write filename, dump
    end
    
    def show
        "{%s: at %i:%i - %i×%i}" % [text, x, y, width, height]
    end

    def archimedean_spiral(t)
      @e ||= cloud.width / cloud.height
      t1 = t * 0.1
      [@e * t1 * Math.cos(t1), t1 * Math.sin(t1)].map(&:round)
    end
    
    def rect
      Rect.new(top, left, right, bottom)
    end
    
    def left
      x + left_offset
    end

    def right
      x + right_offset
    end

    def top
      y + top_offset
    end

    def bottom
      y + bottom_offset
    end
    
    def width
        right_offset - left_offset
    end
    
    def height
        bottom_offset - top_offset
    end
    
    def width=(w)
        self.right_offset = w >> 1
        self.left_offset = -right_offset
    end

    def height=(h)
        self.bottom_offset = h >> 1
        self.top_offset = -bottom_offset
    end
  end
end
