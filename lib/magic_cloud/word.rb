# encoding: utf-8
require_relative './shape'

module MagicCloud
  # Class representing individual word in word cloud
  class Word < Shape
    DEFAULT_FONT_FAMILY = 'Impact'
    DEFAULT_PALETTE = MagicCloud::PALETTES[:category20]
    DEFAULT_ANGLES = [0, 90, 180] # FIXME - shouldn't it be [-90,0,90]?

    def initialize(text, options)
      super()
      @text, @options = text.to_s, options

      @font_size = options.fetch(:font_size)

      @font_family = options.fetch(:font_family, DEFAULT_FONT_FAMILY)

      @color = options.fetch(:color, DEFAULT_PALETTE.sample)
      @rotate = options.fetch(:rotate, DEFAULT_ANGLES.sample)
    end

    attr_reader :text, :options,
      :font_size, :font_family, :color, :rotate

    def draw(canvas, opts = {})
      canvas.draw_text(text, drawing_options.merge(x: x, y: y).merge(opts))
    end

    def measure(canvas)
      canvas.measure_text(text, drawing_options)
    end

    def inspect
      "#<#{self.class} #{text}:#{options}>"
    end

    private

    def drawing_options
      {
        color: color,
        font_size: font_size,
        font_family: font_family,
        rotate: rotate
      }
    end
  end
end
