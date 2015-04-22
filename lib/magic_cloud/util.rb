# encoding: utf-8
module MagicCloud
  # rubocop:disable Style/Documentation
  module Util
    module EnsureHashes
      def ensure_hashes(words)
        words.map{|w|
          case w
          when Hash
            w
          when Array
            w.size == 2 or
              fail ArgumentError, "Unprocessable word: #{w}."\
                'Expecting either hash, or [word, size] pair'

            {text: w.first, font_size: w.last}
          else
            fail ArgumentError, "Unprocessable word: #{w}."\
              'Expecting either hash, or [word, size] pair'
          end
        }
      end
    end
  end
  # rubocop:enable Style/Documentation
end
