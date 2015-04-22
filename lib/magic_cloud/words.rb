# encoding: utf-8
module MagicCloud
  class Words < Array
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
