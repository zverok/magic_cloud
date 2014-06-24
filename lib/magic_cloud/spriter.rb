# encoding: utf-8
class MagicCloud
  class Spriter
    include Magick

    # so it was in d3.layouts.cloud... don't know
    CW = 1 << 11
    CH = 1 << 11
    
    def initialize(cloud)
      @cloud = cloud
      @canvas = Image.new(CW, CH){|i| i.background_color =  'transparent'}
    end
    
    def make_draw
      Draw.new.tap{|d|
        d.text_align(CenterAlign)
        d.font_style(NormalStyle)
        d.font_family('Arial')
        d.fill('red')
      }
    end
    
    def sprite_all!(tags)
      x = 0
      y = 0
      maxh = 0
      last_idx = 0
      
      #reset_canvas!
      
      tags.each_with_index do |tag, idx|
        draw = make_draw
        
        #c.font = d.style + " " + d.weight + " " + ((d.size + 1) / ratio).to_i + "px " + d.font;
        draw.pointsize = tag.size
        
        metrics = draw.get_type_metrics(tag.text + 'm')
        w = metrics.width
        h = metrics.height

        if tag.rotate
          sr = Math.sin(tag.rotate * CLOUD_RADIANS)
          cr = Math.cos(tag.rotate * CLOUD_RADIANS)
          wcr = w * cr
          wsr = w * sr
          hcr = h * cr
          hsr = h * sr

          w = ([(wcr + hsr).abs, (wcr - hsr).abs].max.to_i + 0x1f) >> 5 << 5;
          h = [(wsr + hcr).abs, (wsr - hcr).abs].max.to_i
        else
          w = (w + 0x1f) >> 5 << 5;
        end

        maxh = h if h > maxh

        if x + w >= CW
          x = 0
          y += maxh
          maxh = 0
        end

        if y + h >= CH
          load_sprites(tags[last_idx...idx])
          reset_canvas!
          last_idx = idx
          x = 0
          y = 0
          maxh = 0
        end

        draw.translate(x + (w >> 1), y + (h >> 1))
        draw.rotate(tag.rotate) if tag.rotate 

        draw.text(0, 0, tag.text)

        draw.draw(canvas)
        
        tag.width = w
        tag.height = h
        tag.xoff = x
        tag.yoff = y
        x += w
      end
      
      load_sprites(tags[last_idx..-1])
    end
    
    def load_sprites(tags)
      canvas.write('tmp/test.png')
      pixels = canvas.export_pixels(0, 0, CW, CH, 'RGBA')
      
      tags.each do |tag|
        draw = Draw.new
        draw.text_align(CenterAlign)

        w = tag.width
        h = tag.height
        
        sprite = @cloud.board.sprite(w, h)

        x = tag.xoff
        y = tag.yoff
        
        seen = false
        seen_row = -1
        
        # can't use h.times{|dy|, because of dy changing inside cycle
        dy = 0 
        while dy < h 
          w.times do |dx|
            pixel = pixels[((y + dy) * CW + (x + dx)) << 2]
            sprite.add_pixel(dx, dy, pixel)
            seen ||= pixel
          end
          
          if seen
            seen_row = dy
          else
            tag.top_offset += 1
            h -= 1
            dy -= 1
            y += 1
          end
          dy += 1          
        end
        
        tag.bottom_offset = tag.top_offset + seen_row
        tag.sprite = sprite
      end
    end
    
    private

    attr_reader :canvas
    
    def reset_canvas!
      #c.clearRect(0, 0, CW, CH)
    end
  end
end
