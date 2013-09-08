# -*- coding: utf-8 -*-

module DXRubySDL
  class Font
    attr_reader :size

    def initialize(size, fontname = '', hash = {})
      @size = size
    end
  end
end
