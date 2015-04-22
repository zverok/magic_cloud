# encoding: utf-8
module MagicCloud
  # Utility scale functions
  module Scale
    module_function

    FONT_MIN = 10
    FONT_MAX = 100

    def log(words, min = FONT_MIN, max = FONT_MAX)
      scale(words, min, max){|x| x.zero? ? 0 : Math.log(x) / Math.log(10)}
    end

    def linear(words, min, max)
      scale(words, min, max){|x| x}
    end

    def sqrt(words, min, max)
      scale(words, min, max){|x| Math.sqrt(x)}
    end

    def custom(words, min, max, &normalizer)
      scale(words, min, max, &normalizer)
    end

    private

    module_function

    extend Util::EnsureHashes

    # rubocop:disable Metrics/AbcSize
    def scale(words, target_min, target_max, &normalizer)
      words = ensure_hashes(words)
      
      source_min = normalizer.call(words.map{|w| w[:font_size]}.min)
      source_max = normalizer.call(words.map{|w| w[:font_size]}.max)

      koeff = (target_max - target_min).to_f / (source_max - source_min)

      words.map{|w|
        source_size = normalizer.call(w[:font_size])
        target_size = ((source_size - source_min).to_f * koeff + target_min).to_i

        w.merge(font_size: target_size)
      }
    end
    # rubocop:enable Metrics/AbcSize
  end
end
