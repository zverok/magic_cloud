# encoding: utf-8
require_relative './collision_board'

module MagicCloud
  # Main magic of magic cloud - layouting shapes without collisions.
  # Also, alongside with CollisionBoard -  the slowest and
  # algorithmically trickiest part.
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
        next unless find_place(shape, bounds)

        visible_shapes.push(shape)

        if bounds
          bounds.adjust!(shape.rect)
        else
          bounds = shape.rect
        end
      end

      visible_shapes
    end

    private

    class PlaceNotFound < RuntimeError
    end

    # Incapsulating place lookup process
    class Place
      def initalize(layouter, shape)
        @layouter, @shape = layouter, shape

        @start_x = (@layouter.width/2 + (@layouter.width - @shape.width) * (rand-0.5)/2).to_i
        @start_y = (@layouter.height/2 + (@layouter.height - @shape.height) * (rand-0.5)/2).to_i

        @max_delta = Math.sqrt(@layouter.width**2 + @layouter.height**2)
        @dt = rand < 0.5 ? 1 : -1 # direction of spiral
        @t = -dt
        @spiral = make_spiral(@shape.size)
      end

      def next!
        @t += @dt
        dx, dy = @spiral.call(t)

        # no chances to find place
        fail PlaceNotFound if [dx, dy].map(&:abs).min > @max_delta

        @shape.x = @start_x + dx
        @shape.y = @start_y + dy
      end

      def ready?
        !out_of_board? && !@layouter.board.collides?(shape)
      end

      private

      def out_of_board?
        @shape.left < 0 || @shape.top < 0 ||
          @shape.right > @layouter.width || @shape.bottom > @layouter.height
      end

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

    def find_place(shape)
      place = Place.new(self, shape)
      start = Time.now
      steps = 0
      
      loop do
        steps += 1
        place.next!

        next unless place.ready?

        board.add(shape)
        Debug.logger.info "Place for #{shape.inspect} found " \
          "in #{steps} steps (#{Time.now-start} sec)"

        break
      end

      true
    rescue PlaceNotFound
      Debug.logger.warn "No place for #{shape.inspect} " \
        "in #{step} steps (#{Time.now-start} sec)"

      false
    end
  end
end
