# -*- coding: utf-8 -*-

module DXRubySDL
  class Sprite
    attr_accessor :x
    attr_accessor :y
    attr_accessor :image

    def initialize(x = 0, y = 0, image = nil)
      @x = x
      @y = y
      @image = image
    end
  end
end
