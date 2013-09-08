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
  end
end
