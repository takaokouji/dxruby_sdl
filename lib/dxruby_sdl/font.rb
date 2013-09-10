# -*- coding: utf-8 -*-

module DXRubySDL
  class Font
    attr_reader :size
    attr_reader :_ttf

    @font_cache = {}

    def initialize(size, fontname = '', hash = {})
      @size = size

      if !SDL::TTF.init?
        SDL::TTF.init
      end
      if !(path = FONTS[fontname.downcase])
        path = FONTS.first.last
      end
      font_cache = Font.instance_variable_get('@font_cache')
      args = [path, size]
      if font_cache.key?(args)
        @_ttf = font_cache[args]
      else
        @_ttf = font_cache[args] = SDL::TTF.open(*args)
      end
    end

    private

    # :nocov:
    if /darwin/ =~ RUBY_PLATFORM
      FONTS = {
        'osaka' => '/Library/Fonts/osaka.ttf',
        'IPA ゴシック' => '/Library/Fonts/ipag.ttf',
        'IPA Pゴシック' => '/Library/Fonts/ipagp.ttf',
      }
    elsif /linux/ =~ RUBY_PLATFORM
      FONTS = {
        'IPA ゴシック' => '/usr/share/fonts/opentype/ipafont-gothic/ipag.ttf',
        'IPA Pゴシック' => '/usr/share/fonts/opentype/ipafont-gothic/ipagp.ttf',
      }
    end
    # :nocov:
  end
end
