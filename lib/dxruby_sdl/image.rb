# -*- coding: utf-8 -*-

module DXRubySDL
  class Image
    include Color

    attr_reader :_surface

    def self.load(filename, x = nil, y = nil, width = nil, height = nil)
      image = new(0, 0)
      surface = SDL::Surface.load(filename)
      image.instance_variable_set('@_surface', surface)
      return image
    end

    def self.load_tiles(filename, xcount, ycount)
      surface = SDL::Surface.load(filename)
      width = surface.w / xcount
      height = surface.h / ycount
      images = []
      ycount.times do |y|
        xcount.times do |x|
          image = new(0, 0)
          s = surface.copy_rect(x * width, y * height, width, height)
          image.instance_variable_set('@_surface', s)
          images << image
        end
      end
      return images
    end

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

    def slice(x, y, width, height)
      s = @_surface.copy_rect(x, y, width, height)
      image = Image.new(0, 0)
      image.instance_variable_set('@_surface', s)
      return image
    end

    def line(x1, y1, x2, y2, color)
      lock do
        @_surface.draw_line(x1, y1, x2, y2,
                            to_sdl_color(color), true, to_sdl_alpha(color))
      end
    end

    def circle(x, y, r, color)
      lock do
        @_surface.draw_circle(x, y, r, to_sdl_color(color), false, true,
                              to_sdl_alpha(color))
      end
    end

    def circle_fill(x, y, r, color)
      lock do
        @_surface.draw_circle(x, y, r, to_sdl_color(color), true, false,
                              to_sdl_alpha(color))
      end
    end

    def box(x1, y1, x2, y2, color)
      x = x1 < x2 ? x1 : x2
      w = (x2 - x1).abs
      y = y1 < y2 ? y1 : y2
      h = (y2 - y1).abs
      lock do
        @_surface.draw_rect(x, y, w, h, to_sdl_color(color), false,
                            to_sdl_alpha(color))
      end
    end

    def box_fill(x1, y1, x2, y2, color)
      x = x1 < x2 ? x1 : x2
      w = (x2 - x1).abs
      y = y1 < y2 ? y1 : y2
      h = (y2 - y1).abs
      lock do
        @_surface.draw_rect(x, y, w, h, to_sdl_color(color), true,
                            to_sdl_alpha(color))
      end
    end

    # rubocop:disable SymbolName
    class << self
      alias_method :loadTiles, :load_tiles
      alias_method :load_to_array, :load_tiles
      alias_method :loadToArray, :load_to_array
    end
    alias_method :circleFill, :circle_fill
    alias_method :boxFill, :box_fill
    # rubocop:enable SymbolName

    private

    def lock(&block)
      if SDL::Surface.auto_lock?
        yield
      else
        begin
          @_surface.lock
          yield
        ensure
          @_surface.unlock
        end
      end
    end
  end
end
