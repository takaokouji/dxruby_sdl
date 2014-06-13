# -*- coding: utf-8 -*-

module DXRubySDL
  module Color

    # preset constant color names. [alpha, R, G, B]
    # C_DEFAULT is a transparent color.
    C_BLACK   = [255,   0,   0,   0]
    C_RED     = [255, 255,   0,   0]
    C_GREEN   = [255,   0, 255,   0]
    C_BLUE    = [255,   0,   0, 255]
    C_YELLOW  = [255, 255, 255,   0]
    C_CYAN    = [255,   0, 255, 255]
    C_MAGENTA = [255, 255,   0, 255]
    C_WHITE   = [255, 255, 255, 255]
    C_DEFAULT = [  0,   0,   0,   0]

    module_function

    def to_sdl_color(color)
      if color.length == 4
        return color[1..3]
      else
        return color
      end
    end

    def to_sdl_alpha(color)
      if color.length == 4
        return color[0]
      else
        return nil
      end
    end

    def to_sdl_rgba(color)
      if color.length == 3
        return [*color, 255]
      end
        return [*to_sdl_color(color), to_sdl_alpha(color)]
    end
  end
end
