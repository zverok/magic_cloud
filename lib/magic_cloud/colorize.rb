# encoding: utf-8
require_relative './palettes'

module MagicCloud
  # Utility colorizing functions
  module Colorize
    module_function

    extend Util::EnsureHashes

    def palette(words, palette)
      palette = PALETTES.fetch(palette) if palette.is_a?(Symbol)

      ensure_hashes(words).map{|w| w.merge(color: palette.sample)}
    end
  end
end
