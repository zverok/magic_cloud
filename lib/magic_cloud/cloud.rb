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
    def initialize(words, _options = {})
      @words = ensure_hashes(words).
               map(&Word.method(:new)).
               sort_by(&:font_size).reverse
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

    include Util::EnsureHashes
  end
end
