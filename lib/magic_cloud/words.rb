# encoding: utf-8
module MagicCloud
  # Array based class for storing Words for word cloud and preparing them
  class Words < Array
    include Util::EnsureHashes

    def initialize(other)
      super(ensure_hashes(other))
    end
    
    def colorize(palette)
      Words.new(Colorize.palette(self, palette))
    end

    def rotate(algo, *arg)
      Words.new(Rotate.send(algo, self, *arg))
    end

    def scale(algo, *arg, &block)
      Words.new(Scale.send(algo, self, *arg, &block))
    end

    def to_cloud
      Cloud.new(self)
    end
  end
end
