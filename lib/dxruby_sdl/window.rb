# -*- coding: utf-8 -*-

require 'dxruby_sdl/window/fpstimer'
require 'set'

module DXRubySDL
  module Window
    @current_key_state = Set.new
    @last_key_state = Set.new
    @last_mouse_state = [false, false, false]

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
      @scale ||= 1
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

          keys = (@last_key_state - @current_key_state)
          if keys.length > 0
            SDL::Key.scan
            keys.each do |key|
              if SDL::Key.press?(key)
                @current_key_state.add(key)
              end
            end
          end
          @last_key_state = @current_key_state
          @current_key_state = Set.new
          @last_mouse_state = SDL::Mouse.state
        end
      end
    end

    def draw(x, y, image, z = 0)
      screen.put(image._surface, x, y)
    end

    def draw_font(x, y, string, font, hash = {})
      if hash[:color]
        r, g, b = *hash[:color]
      else
        r, g, b = 255, 255, 255
      end
      font._ttf.draw_blended_utf8(screen, string, x, y, r, g, b)
    end

    def open_filename(filter, title)
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
