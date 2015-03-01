# encoding: utf-8
require_relative './bit_matrix'

module MagicCloud
  # Incapsulates sprite maker for any Shape, able to draw itself.
  module Spriter
    # Sprite is basically a 2-dimensional matrix of 1s and 0s,
    # representing "filled" and "empty" pixeslf of the shape to layout.
    class Sprite < BitMatrix
      def self.extract(rect, pixels)
        sprite = new(rect.width, rect.height)

        (0...rect.height).each do |y|
          (0...rect.width).each do |x|
            # each 4-th byte of RGBA - 1 or 0
            bit = pixels[(y * rect.width + x) * 4]
            sprite.put(x, y, bit.zero? ? 0 : 1)
          end
        end

        sprite
      end
    end

    def self.make_sprites!(shapes)
      Debug.logger.info "Starting sprites creation"
      
      shapes.each do |shape|
        canvas = Canvas.new(1024, 1024)
        rect = shape.draw(canvas, color: 'red')
        canvas.render.write("tmp/sprites/#{shape.text}.png")
        shape.sprite = Sprite.extract(
          rect,
          canvas.pixels(rect.width, rect.height))

        Debug.logger.debug "Sprite for #{shape.inspect} made: " \
          "#{shape.sprite.width}×#{shape.sprite.height}"
      end

      Debug.logger.info "Sprites successfully created"
    end
  end
end
