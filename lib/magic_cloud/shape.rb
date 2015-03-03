# encoding: utf-8
module MagicCloud
  # Basic "abstract shape" class, with all primitive functionality
  # necessary for use it in Spriter and Layouter.
  #
  # Word for wordcloud is inherited from it, and its potentially
  # possible to inherit other types of shapes and layout them also.
  class Shape
    attr_accessor :sprite, :x, :y

    def initialize
      @x = 0
      @y = 0
    end

    def width
      sprite.width
    end

    def height
      sprite.height
    end

    def left
      x
    end

    def right
      x + width
    end

    def top
      y
    end

    def bottom
      y + height
    end

    def rect
      Rect.new(x, y, x + width, y + height)
    end

    # returns rect
    def draw(*)
      fail NotImplementedError
    end
  end
end
