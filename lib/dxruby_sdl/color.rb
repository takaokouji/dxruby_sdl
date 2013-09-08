# -*- coding: utf-8 -*-

module DXRubySDL
  module Color
    module_function

    def to_sdl_color(color)
      if color.length == 4
        return color[0..2]
      else
        color
      end
    end

    def to_sdl_alpha(color)
      if color.length == 4
        return color[3]
      else
        return 255
      end
    end
  end
end
