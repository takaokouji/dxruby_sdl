# -*- coding: utf-8 -*-

module DXRubySDL
  module Input
    module_function

    def x(pad_number = 0)
      SDL::Key.scan
      res = 0
      if SDL::Key.press?(SDL::Key::LEFT)
        res -= 1
      end
      if SDL::Key.press?(SDL::Key::RIGHT)
        res += 1
      end
      return res
    end

    def y(pad_number = 0)
      SDL::Key.scan
      res = 0
      if SDL::Key.press?(SDL::Key::UP)
        res -= 1
      end
      if SDL::Key.press?(SDL::Key::DOWN)
        res += 1
      end
      return res
    end
  end
end
