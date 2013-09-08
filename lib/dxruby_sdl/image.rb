# -*- coding: utf-8 -*-

module DXRubySDL
  class Image
    attr_reader :width
    attr_reader :height

    def initialize(width, height, color = [0, 0, 0, 0])
      @width = width
      @height = height
      @color = color
    end

    def line(x1, y1, x2, y2, color)
    end
  end
end
