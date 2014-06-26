# encoding: utf-8
class MagicCloud
  DEFAULT_WIDTH = 256
  DEFAULT_HEIGHT = 256
  
  def initialize(words, width = DEFAULT_WIDTH, height = DEFAULT_HEIGHT)
    @words, @width, @height = words, width, height

    @tags = words.map{|word, value|
      Tag.new(word, value, self)
    }.sort_by(&:size).reverse

    @board = BitCollisionBoard.new(width, height)
    #@board = MaskCollisionBoard.new(width, height)
    @bounds = nil
    
    @visible_tags = []
    layout!
  end
  
  def draw(palette = nil)
    palette ||= Color20.new
    
    img = Magick::Image.new(width, height)
    
    visible_tags.each_with_index do |tag, idx|
      canvas = Magick::Draw.new
      canvas.text_align(Magick::CenterAlign)
      canvas.font_style(Magick::NormalStyle)
      canvas.font_family('Arial')

      canvas.pointsize = tag.size
      canvas.fill = palette.color(idx)
      canvas.translate(tag.x, tag.y)
      canvas.rotate(tag.rotate) if tag.rotate 
      canvas.text 0, 0, tag.text
      canvas.draw(img)
    end
    
    img
  end
    
  attr_reader :words, :width, :height
  attr_reader :tags, :visible_tags
  attr_reader :bounds, :board

  def layout!
    make_sprites!

    layout_sprites!
  end
  
  def make_sprites!
    spriter = Spriter.new(self)
    spriter.sprite_all!(tags)
  end
    
  def layout_sprites!
    tags.each_with_index do |tag, i|
      #p "tag #{i}: #{tag.text} × #{tag.size}"
      # find place (each next tag is harder to place)
      if tag.find_place
        visible_tags.push(tag)
        
        if bounds
          bounds.adjust!(tag.rect)
        else 
          @bounds = tag.rect
        end
      end
    end
  end
end

require 'magic_cloud/rect'
require 'magic_cloud/spriter'
require 'magic_cloud/palettes'
require 'magic_cloud/tag'
require 'magic_cloud/collision_board'
