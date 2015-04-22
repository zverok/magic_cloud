# encoding: utf-8
require_relative './rect'
require_relative './canvas'

require_relative './word'

require_relative './layouter'
require_relative './spriter'

require_relative './debug'

module MagicCloud
  # Main word-cloud class. Takes words with sizes, returns image
  class Cloud
    # Creates your cloud.
    # It takes array of words, which can be either array of [word, size] pairs,
    # or array of hashes. In the latter case, each item should contain
    # at least `:text` and `:font_size` keys. It also can contain the next
    # keys:
    # * `:color`: hex color, or any other RMagick color string
    #   (See [Color names][http://www.imagemagick.org/RMagick/doc/imusage.html])
    # * `:rotate`:
    # * `:font_family`:
    #
    # @param words [Array] array of words to put on cloud
    def initialize(words)
      @words = ensure_hashes(words).
               map(&Word.method(:new)).
               sort_by(&:font_size).reverse
    end

    attr_reader :words

    # Draws your word cloud onto RMagick::Image
    #
    # @param width [Fixnum] image width, pixels
    # @param height [Fixnum] image height, pixels
    # @return [RMagick::Image] Image[http://www.imagemagick.org/RMagick/doc/image1.html] object
    def draw(width, height)
      shapes = words
      
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

    include Util::EnsureHashes
  end
end
