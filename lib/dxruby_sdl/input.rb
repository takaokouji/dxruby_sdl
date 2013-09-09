# -*- coding: utf-8 -*-

module DXRubySDL
  module Input
    module_function

    def x(pad_number = 0)
      res = 0
      if key_press?(SDL::Key::LEFT)
        res -= 1
      end
      if key_press?(SDL::Key::RIGHT)
        res += 1
      end
      return res
    end

    def y(pad_number = 0)
      res = 0
      if key_press?(SDL::Key::UP)
        res -= 1
      end
      if key_press?(SDL::Key::DOWN)
        res += 1
      end
      return res
    end

    def pad_down?(button_code, pad_number = 0)
      if button_code == P_BUTTON0 && key_press?(SDL::Key::Z) ||
          button_code == P_BUTTON1 && key_press?(SDL::Key::X) ||
          button_code == P_BUTTON2 && key_press?(SDL::Key::C) ||
          ((j = joystick(pad_number)) && j.button(button_code))
        return true
      end
      return false
    end

    private

    @joysticks = []

    class << self

      private

      def key_press?(key)
        SDL::Key.scan
        return SDL::Key.press?(key)
      end

      def joystick(pad_number)
        if pad_number >= SDL::Joystick.num
          return nil
        end
        if !@joysticks[pad_number]
          @joysticks[pad_number] = SDL::Joystick.open(pad_number)
        end
        return @joysticks[pad_number]
      end
    end
  end
end
