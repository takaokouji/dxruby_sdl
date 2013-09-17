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
      if !(path = (FONTS[fontname] || FONT_ALIASES[fontname]))
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

    def get_width(string)
      return @_ttf.text_size(string).first
    end

    alias_method :getWidth, :get_width

    private

    FONTS = {}
    private_constant :FONTS

    FONT_ALIASES = {}
    private_constant :FONT_ALIASES

    # :nocov:
    if /darwin/ =~ RUBY_PLATFORM
      font_info =
        [
         %w[
           ＭＳ\ Ｐゴシック
           /Library/Fonts/Microsoft/MS\ PGothic.ttf
           MS\ Pゴシック
           MS\ PGothic
         ],
         %w[
           ＭＳ\ ゴシック
           /Library/Fonts/Microsoft/MS\ Gothic.ttf
           MS\ ゴシック
           MS\ Gothic
         ],
         %w[
           ＭＳ\ P明朝
           /Library/Fonts/Microsoft/MS\ PMincho.ttf
           MS\ P明朝
           MS\ PMincho
         ],
         %w[
           ＭＳ\ 明朝
           /Library/Fonts/Microsoft/MS\ Mincho.ttf
           MS\ 明朝
           MS\ Mincho
         ],
         %w[
           osaka
           /Library/Fonts/osaka.ttf
         ],
         %w[
           IPA\ Pゴシック
           /Library/Fonts/ipagp.ttf
           IPA\ PGothic
           ipagp
         ],
         %w[
           IPA\ ゴシック
           /Library/Fonts/ipag.ttf
           IPA\ Gothic
           ipag
         ],
        ]
    elsif /linux/ =~ RUBY_PLATFORM
      font_info =
        [
         %w[
           梅Pゴシック
           /usr/share/fonts/truetype/horai-umefont/ume-pgo4.ttf
           ume-pgo4
           ＭＳ\ Ｐゴシック
           MS\ Pゴシック
           MS\ PGothic
         ],
         %w[
           梅ゴシック
           /usr/share/fonts/truetype/horai-umefont/ume-tgo4.ttf
           ume-tgo4
           ＭＳ\ ゴシック
           MS\ ゴシック
           MS\ Gothic
         ],
         %w[
           梅P明朝
           /usr/share/fonts/truetype/horai-umefont/ume-pmo3.ttf
           ume-pmo3
           ＭＳ\ P明朝
           MS\ P明朝
           MS\ PMincho
         ],
         %w[
           梅明朝
           /usr/share/fonts/truetype/horai-umefont/ume-tmo3.ttf
           ume-tmo3
           ＭＳ\ 明朝
           MS\ 明朝
           MS\ Mincho
         ],
         %w[
           IPA\ Pゴシック
           /usr/share/fonts/opentype/ipafont-gothic/ipagp.ttf
           IPA\ PGothic
           ipagp
         ],
         %w[
           IPA\ ゴシック
           /usr/share/fonts/opentype/ipafont-gothic/ipag.ttf
           IPA\ Gothic
           ipag
         ],
         %w[
           IPA\ P明朝
           /usr/share/fonts/opentype/ipafont-mincho/ipamp.ttf
           IPA\ PMincho
           ipamp
         ],
         %w[
           IPA\ 明朝
           /usr/share/fonts/opentype/ipafont-mincho/ipam.ttf
           IPA\ Mincho
           ipam
         ],
        ]
    end
    # :nocov:
    font_info.each do |name, path, *aliases|
      if File.exist?(path)
        FONTS[name] = path
        aliases.each do |a|
          FONT_ALIASES[a] = path
        end
      end
    end
  end
end
