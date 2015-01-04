# encoding: utf-8
require_relative './bit_matrix'

module MagicCloud
  module Spriter
    class Sprite < BitMatrix
      def self.extract(rect, pixels)
        sprite = new(rect.width, rect.height)
        
        (0...rect.height).each do |y|
          (0...rect.width).each do |x|
            bit = pixels[(y * rect.width + x) * 4] # each 4-th byte of RGBA - 1 or 0
            sprite.put(x, y, bit.zero? ? 0 : 1)
          end
        end
        
        sprite
      end
    end
    
    def self.make_sprites!(shapes)
      shapes.each do |shape|
        canvas = Canvas.new(1024,1024)
        rect = shape.draw(canvas, color: 'red')
        canvas.render.write("tmp/sprites/#{shape.text}.png")
        shape.sprite = Sprite.extract(rect, canvas.pixels(rect.width, rect.height))

        Debug.logger.info "Sprite for #{shape.inspect} made: #{shape.sprite.width}×#{shape.sprite.height}"
      end
    end
  end
end
