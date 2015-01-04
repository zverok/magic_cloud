# encoding: utf-8
require_relative './tag'
require_relative './layouter'
require_relative './spriter'
require_relative './debug'
require_relative './canvas'
require_relative './rect'

module MagicCloud
  class Cloud
    def initialize(words, options = {})
      @words = words.sort_by(&:last).reverse
      @options = options
      @scaler = make_scaler(words, options[:scale] || :log)
      @rotator = make_rotator(options[:rotate] || :square)
      @palette = make_palette(options[:palette] || :default)
    end
    
    PALETTES = {
      color20: %w[
        #1f77b4 #aec7e8 #ff7f0e #ffbb78 #2ca02c 
        #98df8a #d62728 #ff9896 #9467bd #c5b0d5 
        #8c564b #c49c94 #e377c2 #f7b6d2 #7f7f7f 
        #c7c7c7 #bcbd22 #dbdb8d #17becf #9edae5
      ]
    }
    
    def draw(width, height)
      # FIXME: do it in init, for specs would be happy
      shapes = @words.each_with_index.map{|(word, size), i| 
        Tag.new(
          word, 
          font_size: scaler.call(word, size, i), 
          color: palette.call(word, i),
          rotate: rotator.call(word, i)
        )
      }
      
      Debug.reinit!
      
      Spriter.make_sprites!(shapes)
      layouter = Layouter.new(width, height)
      visible = layouter.layout!(shapes)
      
      canvas = Canvas.new(width, height, 'white')
      visible.each{|sh| sh.draw(canvas)}
      canvas.render
    end
    
    private
    
    attr_reader :palette, :rotator, :scaler
    
    def make_palette(source)
      case source
      when :default
        make_const_palette(:color20)
      when :color20
        make_const_palette(source)
      else
        fail ArgumentError, "Unknown palette: #{source.inspect}"
      end
    end
    
    def make_const_palette(sym)
      palette = PALETTES[sym] or 
        fail(ArgumentError, "Unknown palette: #{sym.inspect}")
      
      ->(word, index){palette[index % palette.size]}
    end
    
    def make_rotator(source)
      case source
      when :none
        ->(*){0}
      when :square
        ->(*){ (rand * 2).to_i * 90 }
      when :free
        ->(*){ (((rand * 6) - 3) * 30).round }
      when Proc
        source
      when ->(s){s.respond_to?(:rotate)}
        ->(word, index){source.rotate(word, index)}
      else
        fail ArgumentError, "Unknown rotation algo: #{source.inspect}"
      end
    end

    # FIXME: should be options too
    FONT_MIN = 10
    FONT_MAX = 100
    
    def make_scaler(words, algo)
      norm = 
        case algo
        when :no
          return ->(word, size, index){size} # no normalization, treat tag weights as font size
        when :linear
          ->(x){x}
        when :log
          ->(x){Math.log(x) / Math.log(10)}
        when :sqrt
          ->(x){Math.sqrt(x)}
        else
          fail ArgumentError, "Unknown scaling algo: #{algo.inspect}"
        end
      
      smin = norm.call(words.map(&:last).min)
      smax = norm.call(words.map(&:last).max)
      koeff = (FONT_MAX-FONT_MIN).to_f/(smax-smin)
      
      ->(word, size, index){
        ssize = norm.call(size)
        ((ssize - smin).to_f*koeff + FONT_MIN).to_i
      }
    end
  end
end
