# -*- coding: utf-8 -*-

require 'dxruby_sdl/window/fpstimer'

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

    def bgcolor
      @bgcolor ||= DEFAULTS[:background_color]
    end

    def bgcolor=(val)
      @bgcolor = val
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
            when SDL::Event::KeyDown, SDL::Event::KeyUp
              Input.send(:handle_key_event, event)
            end
          end

          screen.fill_rect(0, 0, width, height, bgcolor)

          yield

          screen.flip

          Input.send(:store_last_state)
        end
      end
    end

    def draw(x, y, image, z = 0)
      if z != 0
        raise NotImplementedError, 'Window.draw(x, y, image, z != 0)'
      end
      screen.put(image._surface, x, y)
    end

    def draw_scale(x, y, image, scalex, scaley, centerx = nil, centery = nil, z = 0)
      opt = {
        scale_x: scalex,
        scale_y: scaley,
        center_x: centerx,
        center_y: centery,
      }
      draw_ex(x, y, image, opt)
    end

    def draw_ex(x, y, image, hash = {})
      if hash[:z] && hash[:z] != 0
        raise NotImplementedError, 'Window.draw_ex(x, y, image, z: != 0)'
      end
      option = {
        angle: 0,
        scale_x: 1,
        scale_y: 1,
        center_x: 0,
        center_y: 0,
      }.merge(hash)
      SDL::Surface.transform_blit(image._surface, screen,
                                  option[:angle],
                                  option[:scale_x], option[:scale_y],
                                  option[:center_x], option[:center_y],
                                  x + option[:center_x], y + option[:center_y],
                                  0)
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

    def windowed?
      !@_fullscreen
    end

    def windowed=(val)
      @_fullscreen = !val
    end

    class << self
      attr_writer :width
      attr_writer :height
      attr_writer :scale

      alias_method :drawScale, :draw_scale
      alias_method :drawEx, :draw_ex
      alias_method :drawFont, :draw_font
      alias_method :openFilename, :open_filename
    end

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
        flags =
          SDL::HWSURFACE | SDL::ASYNCBLIT | SDL::HWPALETTE | SDL::DOUBLEBUF
        flags |= SDL::FULLSCREEN unless windowed?
        return SDL::Screen.open(width, height, 0, flags)
      end
    end
  end
end
