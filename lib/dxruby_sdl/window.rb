# -*- coding: utf-8 -*-

require 'dxruby_sdl/window/fpstimer'

module DXRubySDL
  module Window
    module_function

    def _screen
      return SDL::Screen.get
    rescue SDL::Error
      return SDL::Screen.open(DEFAULTS[:width], DEFAULTS[:height], 16,
                              SDL::SWSURFACE)
    end

    def loop(&block)
      _screen.fill_rect(0, 0, DEFAULTS[:width], DEFAULTS[:height],
                        DEFAULTS[:background_color])
      _screen.update_rect(0, 0, 0, 0)

      timer = FPSTimer.instance
      timer.reset

      Kernel.loop do
        while (event = SDL::Event.poll)
          case event
          when SDL::Event::Quit
            exit
          end
        end

        timer.wait_frame do
          yield
          _screen.update_rect(0, 0, 0, 0)
        end
      end
    end

    def draw(x, y, image)
      _screen.put(image.surface, x, y)
    end

    private

    DEFAULTS = {
      width: 640,
      height: 480,
      background_color: [0, 0, 0],
    }
    private_constant :DEFAULTS
  end
end
