# encoding: utf-8
require_relative './collision_board'

module MagicCloud
  class Layouter
    def initialize(w, h, options = {})
      @board = CollisionBoard.new(w, h)

      @options = options
    end
    
    attr_reader :board
    
    def width
      board.width
    end
    
    def height
      board.height
    end
    
    def layout!(shapes)
      visible_shapes = []
      bounds = nil

      
      shapes.each do |shape|
        if find_place(shape, bounds)
          visible_shapes.push(shape)
          
          if bounds
            bounds.adjust!(shape.rect)
          else 
            bounds = shape.rect
          end
        end
      end
      
      visible_shapes
    end
    
    private
    
    def find_place(shape, bounds)
      # first, place it randomly
      # each coord is like - from center, in random direction, 
      # random shift, allowing to place it immediately
      start_x = (width/2 + (width - shape.width)*(rand-0.5)/2).to_i
      start_y = (height/2 + (height - shape.height)*(rand-0.5)/2).to_i

      # other possible strategy: start from center
      # produces more sparse cloud, takes more time
      # start_x = (cloud.width/2 + rand(200) - 100).to_i
      # start_y = (cloud.height/2 + rand(200) - 100).to_i
      
      max_delta = Math.sqrt(width**2 + height**2)
      dt = rand < 0.5 ? 1 : -1 # direction of spiral
      t = -dt

      start = Time.now
      
      spiral = make_spiral(shape.size)
      
      step = 0
      
      # FIXME: first check, if sprite can fit inside board

      # looking for the place for this word, moving in spirals from center 
      loop do
        t += dt
        step += 1
        dx, dy = spiral.call(t)
        
        # no chances to find place :(
        break if [dx, dy].map(&:abs).min > max_delta

        shape.x = start_x + dx
        shape.y = start_y + dy

        # out of cloud rectangle, let's try another position
        next if shape.left < 0 || shape.top < 0 || 
          shape.right > width || shape.bottom > height 
            
        if !bounds || !shape.rect.collide?(bounds) || !board.collides?(shape)
          board.add(shape)
          Debug.logger.info "Place for #{shape.inspect} found in #{step} steps"
          
          return true
        end
      end
      
      Debug.logger.warn "No place for #{shape.inspect} in #{step} steps"
      
      false
    end
    
    private
    
    # FIXME: fixme very much
    def make_spiral(step)
      rectangular_spiral(step)
    end

    def archimedean_spiral(size)
      e = width / height
      ->(t){
        t1 = t * size * 0.01
        
        [
          e * t1 * Math.cos(t1), 
          t1 * Math.sin(t1)
        ].map(&:round)
      }
    end
    
    def rectangular_spiral(size)
      dy = 4 * size * 0.1
      dx = dy * width / height
      x = 0
      y = 0
      ->(t){
        sign = t < 0 ? -1 : 1
        
        # zverok: this is original comment & code from d3.layout.cloud.js
        # Looks too witty for me.
        #
        # See triangular numbers: T_n = n * (n + 1) / 2.
        case (Math.sqrt(1 + 4 * sign * t) - sign).to_i & 3
        when 0 then x += dx
        when 1 then y += dy
        when 2 then x -= dx
        else        y -= dy
        end
        
        [x, y].map(&:round)
      }
    end
  end
end
