# -*- coding: utf-8 -*-

module DXRubySDL
  class Image
    include Color

    attr_reader :_surface

    def initialize(width, height, color = [0, 0, 0, 0])
      @color = color

      if width == 0 && height == 0
        return
      end

      @_surface =
        SDL::Surface.new(SDL::SWSURFACE, width, height, Window._screen)
      @_surface.fill_rect(0, 0, width, height, @color)
    end

    def width
      return @_surface.w
    end

    def height
      return @_surface.h
    end

    def line(x1, y1, x2, y2, color)
      @_surface.draw_line(x1, y1, x2, y2,
                          to_sdl_color(color), true, to_sdl_alpha(color))
    end

    def circle(x, y, r, color)
      @_surface.draw_circle(x, y, r, to_sdl_color(color), true,
                            to_sdl_alpha(color))
    end

    def box(x1, y1, x2, y2, color)
      x = x1 < x2 ? x1 : x2
      w = (x2 - x1).abs
      y = y1 < y2 ? y1 : y2
      h = (y2 - y1).abs
      @_surface.draw_rect(x, y, w, h, to_sdl_color(color))
    end

    def self.load(filename, x = nil, y = nil, width = nil, height = nil)
      image = new(0, 0)
      surface = SDL::Surface.load(filename)
      image.instance_variable_set('@_surface', surface)
      return image
    end
  end
end
