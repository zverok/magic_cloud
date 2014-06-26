# encoding: utf-8
class MagicCloud
  class Tag
    def initialize(text, size, cloud)
      @text, @size, @cloud = text.to_s, size, cloud
      
      @x = 0
      @y = 0

      @top_offset = 0
      @bottom_offset = 0
      @left_offset = 0
      @right_offset = 0
      
      #@rotate = (((rand * 6) - 3) * 30).round
      @rotate = (rand * 2).to_i * 90
    end
    
    attr_reader :text, :size, :cloud
    attr_reader :rotate

    attr_reader :x, :y
    attr_reader :top_offset, :bottom_offset, :left_offset, :right_offset

    attr_accessor :xoff, :yoff # used by spriter internally
    
    attr_accessor :prev_intersected_idx # used by collider internally
    
    def x=(nx)
      @x = nx
      refresh
    end

    def y=(ny)
      @y = ny
      refresh
    end
    
    def top_offset=(to)
      @top_offset = to
      refresh
    end
    
    def bottom_offset=(bo)
      @bottom_offset = bo
      refresh
    end
    
    def left_offset=(lo)
      @left_offset = lo
      refresh
    end
    
    def right_offset=(ro)
      @right_offset = ro
      refresh
    end
    
    attr_accessor :sprite
    
    def find_place
      # first, place it randomly
      # each coord is like - from center, in random direction, random shift, allowing to place it immediately
      start_x = (cloud.width/2 + (cloud.width - width)*(rand-0.5)/2).to_i
      start_y = (cloud.height/2 + (cloud.height - height)*(rand-0.5)/2).to_i
      
      max_delta = Math.sqrt(cloud.width**2 + cloud.height**2)
      dt = rand < 0.5 ? 1 : -1 # direction of spiral, I assume
      t = -dt

      start = Time.now

      # looking for the place for this word, moving in spirals from center 
      while true
        t += dt
        dx, dy = archimedean_spiral(t)
        
        break if [dx, dy].map(&:abs).min > max_delta # no chances to find place :(

        self.x = start_x + dx;
        self.y = start_y + dy;

        # out of cloud rectangle, let's try another position
        next if left < 0 || top < 0 || right > cloud.width || bottom > cloud.height 
            
        # d3.layout.cloud: TODO only check for collisions within current bounds.
        if !cloud.bounds || !rect.collide?(cloud.bounds) || !cloud.board.collides?(self)
          cloud.board.add(self)
          #p "...found in #{Time.now-start}, #{t} steps #{start_x}:#{start_y} -> #{x}:#{y}"
          
          return true
        end
      end
      
      #puts "Place not found: #{show} after #{t} steps, started at #{start_x}:#{start_y}, last step: #{dx}:#{dy}"
      
      false
    end
    
    def show
        "{%s: at %i:%i - %i×%i}" % [text, x, y, width, height]
    end

    def archimedean_spiral(t)
      @e ||= cloud.width / cloud.height
      t1 = t * size * 0.01
      [@e * t1 * Math.cos(t1), t1 * Math.sin(t1)].map(&:round)
    end
    
    attr_reader :left, :top, :right, :bottom, :width, :height, :rect
    
    def width=(w)
      self.right_offset = w >> 1
      self.left_offset = -right_offset
    end

    def height=(h)
      self.bottom_offset = h >> 1
      self.top_offset = -bottom_offset
    end
    
    # caching all params instead of onthefly calc
    def refresh
      @left = x + left_offset
      @right = x + right_offset
      @top = y + top_offset
      @bottom = y + bottom_offset
      @width = right_offset - left_offset
      @height = bottom_offset - top_offset
      @rect = Rect.new(left, top, right, bottom)
    end
  end
end
