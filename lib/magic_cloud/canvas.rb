# encoding: utf-8
require 'RMagick'

module MagicCloud
  class Canvas
    def initialize(w, h, back = 'transparent')
      @width, @height = w,h
      @internal = Magick::Image.new(w, h){|i| i.background_color =  back}
    end
    
    attr_reader :internal, :width, :height
    
    RADIANS = Math::PI / 180
    
    def draw_text(text, options = {})
      draw = Magick::Draw.new
      
      draw.font_family = 'Impact'
      draw.font_weight = Magick::NormalWeight
      
      draw.translate(options[:x] || 0, options[:y] || 0)
      draw.pointsize = options[:font_size]
      draw.fill_color(options[:color])
      draw.stroke_color(options[:color])
      draw.gravity(Magick::CenterGravity)
      draw.text_align(Magick::CenterAlign)

      metrics = draw.get_type_metrics('"' + text + 'm"')
      w, h = rotated_metrics(
        metrics.width, 
        metrics.height, 
        options[:rotate] || 0)
      
      draw.translate(w/2, h/2)
      draw.rotate(options[:rotate] || 0)
      draw.translate(0, h/8) # RMagick text_align is really weird, trust me!
      draw.text(0, 0, text)

      draw.draw(@internal)
      
      Rect.new(0, 0, w, h)
    end
    
    def pixels(w = nil, h = nil)
      @internal.export_pixels(0, 0, w || width, h || height, 'RGBA')
    end
    
    def render
      @internal
    end
    
    private
    
    def rotated_metrics(width, height, degrees)
      radians = degrees * Math::PI / 180

      # FIXME: not too clear, just straightforward from d3.cloud
      sr = Math.sin(radians)
      cr = Math.cos(radians)
      wcr = w * cr
      wsr = w * sr
      hcr = h * cr
      hsr = h * sr

      w = [(wcr + hsr).abs, (wcr - hsr).abs].max.to_i
      h = [(wsr + hcr).abs, (wsr - hcr).abs].max.to_i
      
      [w,h]
    end
  end
end
