# -*- coding: utf-8 -*-

module DXRubySDL
  module Color

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
