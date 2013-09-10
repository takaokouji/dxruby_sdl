# -*- coding: utf-8 -*-

require 'dxruby_sdl/window/fpstimer'
require 'set'

module DXRubySDL
  module Window
    module_function

    def width
      @width ||= DEFAULTS[:width]
      return @width
    end

    def height
      @height ||= DEFAULTS[:height]
      return @height
    end

    def scale
      @scale ||= DEFAULTS[:scale]
      return @scale
    end

    def caption
      return SDL::WM.caption[0]
    end

    def caption=(val)
      SDL::WM.set_caption(val, '')
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

          screen.fill_rect(0, 0, width, height, DEFAULTS[:background_color])

          yield

          screen.update_rect(0, 0, 0, 0)

          Input.send(:store_last_state)
        end
      end
    end

    def draw(x, y, image, z = 0)
      screen.put(image._surface, x, y)
    end

    def draw_font(x, y, string, font, hash = {})
      if string.empty?
        return
      end
      if hash[:color]
        r, g, b = *hash[:color]
      else
        r, g, b = 255, 255, 255
      end
      h = font._ttf.height + 1
      string.lines.each.with_index do |line, i|
        line.chomp!
        if line.empty?
          next
        end
        font._ttf.draw_blended_utf8(screen, line, x, y + i * h, r, g, b)
      end
    end

    def open_filename(filter, title)
      # :nocov:
      if /darwin/ =~ RUBY_PLATFORM
        apple_script = <<-EOS
on run
  tell application "Finder"
    activate
    set theImage to choose file
    return theImage as Unicode text
  end tell
end run
        EOS
        s = `osascript -e '#{apple_script}'`
        return s.chomp.sub(/^ "/, '').gsub(/:/, '/')
      else
        raise NotImplementedError, 'Window.open_filename'
      end
      # :nocov:
    end

    # rubocop:disable SymbolName
    class << self
      attr_writer :width
      attr_writer :height
      attr_writer :scale

      alias_method :drawFont, :draw_font
      alias_method :openFilename, :open_filename
    end
    # rubocop:enable SymbolName

    private

    DEFAULTS = {
      width: 640,
      height: 480,
      scale: 1,
      background_color: [0, 0, 0],
    }
    private_constant :DEFAULTS

    class << self

      private

      def screen
        return SDL::Screen.get
      rescue SDL::Error
        return SDL::Screen.open(width, height, 16, SDL::SWSURFACE)
      end
    end
  end
end
