# Notes
# * like d3.layouts.cloud, it uses >> and << for multiplication, though I'm not confident it's effetctive in Ruby

# FIXME: fill = d3.category20(); fill = fill
# Constructs a new ordinal scale with a range of twenty categorical colors: #1f77b4 #aec7e8 #ff7f0e #ffbb78 #2ca02c #98df8a #d62728 #ff9896 #9467bd #c5b0d5 #8c564b #c49c94 #e377c2 #f7b6d2 #7f7f7f #c7c7c7 #bcbd22 #dbdb8d #17becf #9edae5

class MagicCloud
  DEFAULT_WIDTH = 256
  DEFAULT_HEIGHT = 256
  
  CLOUD_RADIANS = Math::PI / 180
  
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
      # find place (each next tag is harder to place)
      if tag.find_place
        visible_tags.push(tag)
        
        if bounds
          bounds.adjust!(tag.rect)
        else 
          @bounds = tag.rect
        end
      else
        puts "Place not found: #{tag.show}"
      end
      dump_board("tmp/tag-#{i}.txt")
    end
  end
  
  def dump_board(filename)
    #data = (0...height).map{|row|
      #(0...(width >> 5)).map{|col|
        #board[row*(width >> 5)+col]
      #}.join("; ")
    #}.join("\n")
    #File.write filename, data
  end
end

require 'magic_cloud/core_ext'
require 'magic_cloud/rect'
require 'magic_cloud/spriter'
require 'magic_cloud/palettes'
require 'magic_cloud/tag'
require 'magic_cloud/collision_board'
