# encoding: utf-8
module MagicCloud
  module Rotate
    module_function
    def none(words)
      rotate(words){0}
    end

    def square(words)
      rotate(words){[-90, 0, 90].sample}
    end

    def free(words)
      rotate(words){(((rand * 6) - 3) * 30).round}
    end

    def arbitrary(words, *angles)
      angles.flatten!
      rotate(words){angles.sample}
    end

    def angles(from, to, count)
      (from..to).step((to - from) / (count - 1)).to_a
    end

    private
    module_function

    extend Util::EnsureHashes

    def rotate(words, &algo)
      ensure_hashes(words).map{|w|
        w.merge(rotate: algo.call)
      }
    end
  end
end
