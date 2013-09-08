# -*- coding: utf-8 -*-

require 'dxruby_sdl/window/fpstimer'

module DXRubySDL
  module Window
    module_function

    def loop(&block)
      screen = SDL.set_video_mode(DEFAULTS[:width], DEFAULTS[:height], 16,
                                  SDL::SWSURFACE)
      screen.fill_rect(0, 0, DEFAULTS[:width], DEFAULTS[:height],
                       DEFAULTS[:background_color])
      screen.update_rect(0, 0, 0, 0)

      timer = FPSTimer.new
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
        end
      end
    end

    def draw(x, y, image)
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
