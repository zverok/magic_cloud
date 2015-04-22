# encoding: utf-8
require_relative './rect'
require_relative './canvas'
require_relative './palettes'

require_relative './word'

require_relative './layouter'
require_relative './spriter'

require_relative './debug'

module MagicCloud
  # Main word-cloud class. Takes words with sizes, returns image
  class Cloud
    def initialize(words, options = {})
      @words = ensure_hashes(words).
               map(&Word.method(:new)).
               sort_by(&:font_size).reverse
        
      #@options = options
      #@scaler = make_scaler(words, options[:scale] || :log)
      #@rotator = make_rotator(options[:rotate] || :square)
      #@palette = make_palette(options[:palette] || :default)
    end

    attr_reader :words

    def draw(width, height)
      Debug.reset!

      spriter = Spriter.new
      spriter.make_sprites!(shapes)

      layouter = Layouter.new(width, height)
      visible = layouter.layout!(shapes)

      canvas = Canvas.new(width, height, 'white')
      visible.each{|sh| sh.draw(canvas)}

      canvas.render
    end

    private

    attr_reader :palette, :rotator, :scaler

    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity,Metrics/AbcSize
    def make_palette(source)
      case source
      when :default
        make_const_palette(:category20)
      when Symbol
        make_const_palette(source)
      when Array
        ->(_, index){source[index % source.size]}
      when Proc
        source
      when ->(s){s.respond_to?(:color)}
        ->(word, index){source.color(word, index)}
      else
        fail ArgumentError, "Unknown palette: #{source.inspect}"
      end
    end

    def make_const_palette(sym)
      palette = PALETTES[sym] or
        fail(ArgumentError, "Unknown palette: #{sym.inspect}")

      ->(_, index){palette[index % palette.size]}
    end

    def make_rotator(source)
      case source
      when :none
        ->(*){0}
      when :square
        ->(*){
          (rand * 2).to_i * 90
        }
      when :free
        ->(*){
          (((rand * 6) - 3) * 30).round
        }
      when Array
        ->(*){
          source.sample
        }
      when Proc
        source
      when ->(s){s.respond_to?(:rotate)}
        ->(word, index){source.rotate(word, index)}
      else
        fail ArgumentError, "Unknown rotation algo: #{source.inspect}"
      end
    end

    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity,Metrics/AbcSize

    include Util::EnsureHashes

  end
end
