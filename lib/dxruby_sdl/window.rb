# -*- coding: utf-8 -*-

require 'dxruby_sdl/window/fpstimer'
require 'set'

module DXRubySDL
  module Window
    @current_key_state = Set.new
    @last_key_state = Set.new
    @last_mouse_state = [false, false, false]

    module_function

    def _screen
      return SDL::Screen.get
    rescue SDL::Error
      return SDL::Screen.open(DEFAULTS[:width], DEFAULTS[:height], 16,
                              SDL::SWSURFACE)
    end

    def fps=(val)
      FPSTimer.instance.fps = val
    end

    def loop(&block)
      timer = FPSTimer.instance
      timer.reset

      Kernel.loop do
        timer.wait_frame do
          while (event = SDL::Event.poll)
            case event
            when SDL::Event::Quit
              exit
            end
          end

          _screen.fill_rect(0, 0, DEFAULTS[:width], DEFAULTS[:height],
                            DEFAULTS[:background_color])

          yield

          _screen.update_rect(0, 0, 0, 0)

          @last_mouse_state = @current_key_state
          @current_key_state = Set.new
          @last_mouse_state = SDL::Mouse.state
        end
      end
    end

    def draw(x, y, image, z = 0)
      _screen.put(image._surface, x, y)
    end

    def draw_font(x, y, string, font, hash = {})
      if hash[:color]
        r, g, b = *hash[:color]
      else
        r, g, b = 255, 255, 255
      end
      font._ttf.draw_blended_utf8(_screen, string, x, y, r, g, b)
    end

    # rubocop:disable SymbolName
    class << self
      alias_method :drawFont, :draw_font
    end
    # rubocop:enable SymbolName

    private

    DEFAULTS = {
      width: 640,
      height: 480,
      background_color: [0, 0, 0],
    }
    private_constant :DEFAULTS
  end
end
