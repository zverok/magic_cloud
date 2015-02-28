# encoding: utf-8
require_relative './shape'

class MagicCloud
  # Class representing individual word in word cloud
  class Tag < Shape
    # FIXME: rename to Word?

    def initialize(text, options)
      @text, @options = text.to_s, options
    end

    attr_reader :text, :options

    def size
      options[:font_size] # FIXME
    end

    def draw(canvas, opts = {})
      canvas.draw_text(text, @options.merge(x: x, y: y).merge(opts))
    end

    def inspect
      "#<Tag #{text}:#{options}>"
    end
  end
end
