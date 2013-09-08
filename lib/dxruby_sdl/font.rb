# -*- coding: utf-8 -*-

module DXRubySDL
  class Font
    attr_reader :size
    attr_reader :_ttf

    def initialize(size, fontname = '', hash = {})
      @size = size

      if !SDL::TTF.init?
        SDL::TTF.init
      end
      @_ttf = SDL::TTF.open('/Library/Fonts/osaka.ttf', size)
    end
  end
end
