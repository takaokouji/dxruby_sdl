# -*- coding: utf-8 -*-

module DXRubySDL
  module Input
    module_function

    def set_repeat(wait, interval)
      SDL::Key.enable_key_repeat(wait, interval)
    end

    def x(pad_number = 0)
      res = 0
      if sdl_key_press?(SDL::Key::LEFT)
        res -= 1
      end
      if sdl_key_press?(SDL::Key::RIGHT)
        res += 1
      end
      return res
    end

    def y(pad_number = 0)
      res = 0
      if sdl_key_press?(SDL::Key::UP)
        res -= 1
      end
      if sdl_key_press?(SDL::Key::DOWN)
        res += 1
      end
      return res
    end

    def pad_down?(button_code, pad_number = 0)
      if button_code == P_BUTTON0 && sdl_key_press?(SDL::Key::Z) ||
          button_code == P_BUTTON1 && sdl_key_press?(SDL::Key::X) ||
          button_code == P_BUTTON2 && sdl_key_press?(SDL::Key::C) ||
          button_code == P_LEFT && sdl_key_press?(SDL::Key::LEFT) ||
          button_code == P_RIGHT && sdl_key_press?(SDL::Key::RIGHT) ||
          button_code == P_UP && sdl_key_press?(SDL::Key::UP) ||
          button_code == P_DOWN && sdl_key_press?(SDL::Key::DOWN) ||
          ((j = joystick(pad_number)) && j.button(button_code))
        return true
      end
      return false
    end

    def pad_push?(button_code, pad_number = 0)
      if button_code == P_BUTTON0 && sdl_key_push?(SDL::Key::Z) ||
          button_code == P_BUTTON1 && sdl_key_push?(SDL::Key::X) ||
          button_code == P_BUTTON2 && sdl_key_push?(SDL::Key::C) ||
          button_code == P_LEFT && sdl_key_push?(SDL::Key::LEFT) ||
          button_code == P_RIGHT && sdl_key_push?(SDL::Key::RIGHT) ||
          button_code == P_UP && sdl_key_push?(SDL::Key::UP) ||
          button_code == P_DOWN && sdl_key_push?(SDL::Key::DOWN) ||
          ((j = joystick(pad_number)) && j.button(button_code))
        return true
      end
      return false
    end

    def mouse_pos_x
      return SDL::Mouse.state[0]
    end

    def mouse_pos_y
      return SDL::Mouse.state[1]
    end

    def key_down?(key_code)
      return sdl_key_press?(to_sdl_key(key_code))
    end

    def key_push?(key_code)
      return sdl_key_push?(to_sdl_key(key_code))
    end

    def mouse_down?(button)
      case button
      when M_LBUTTON
        index = 2
      when M_MBUTTON
        index = 3
      when M_RBUTTON
        index = 4
      end
      return SDL::Mouse.state[index]
    end

    def mouse_push?(button)
      case button
      when M_LBUTTON
        index = 2
      when M_MBUTTON
        index = 3
      when M_RBUTTON
        index = 4
      end
      return SDL::Mouse.state[index] && !@last_mouse_state[index]
    end

    # rubocop:disable SymbolName
    class << self
      alias_method :setRepeat, :set_repeat
      alias_method :padDown?, :pad_down?
      alias_method :padPush?, :pad_push?
      alias_method :mousePosX, :mouse_pos_x
      alias_method :mousePosY, :mouse_pos_y
      alias_method :keyDown?, :key_down?
      alias_method :keyPush?, :key_push?
      alias_method :mouseDown?, :mouse_down?
      alias_method :mousePush?, :mouse_push?
    end
    # rubocop:enable SymbolName

    private

    @current_key_state = Set.new
    @last_key_state = Set.new
    @last_mouse_state = [false, false, false]
    @joysticks = []

    class << self

      private

      KEY_TABLE = {}
      replace_table = {
        'BACK' => 'BACKSPACE',
        'ADD' => 'PLUS',
        'DIVIDE' => 'SLASH',
        'LCONTROL' => 'LCTRL',
        'RCONTROL' => 'RCTRL',
        'SCROLL' => 'SCROLLOCK',
        'GRAVE' => 'BACKQUOTE',
        'LBRACKET' => 'LEFTBRACKET',
        'RBRACKET' => 'RIGHTBRACKET',
        'LWIN' => 'LSUPER',
        'RWIN' => 'RSUPER',
        'YEN' => 'BACKSLASH',
      }
      ::DXRubySDL.constants.grep(/^K_/).each do |k|
        name = k.to_s.sub(/^K_/, '')
        name.gsub!('COMMA', 'PERIOD')
        if replace_table.key?(name)
          name = replace_table[name]
        end
        case name
        when /^\d$/
          name = "K#{name}"
        when /^NUMPAD(.+)$/
          md = Regexp.last_match
          if md[1].length > 1
            name = "KP_#{md[1]}"
          else
            name = "KP#{md[1]}"
          end
        end
        begin
          KEY_TABLE[DXRubySDL.const_get(k)] = SDL::Key.const_get(name.to_sym)
        rescue NameError
        end
      end
      private_constant :KEY_TABLE

      def store_last_state
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
        @current_key_state.clear
        @last_mouse_state = SDL::Mouse.state
      end

      def sdl_key_press?(key)
        SDL::Key.scan
        if SDL::Key.press?(key)
          @current_key_state.add(key)
          return true
        else
          @current_key_state.delete(key)
          return false
        end
      end

      def sdl_key_push?(key)
        return sdl_key_press?(key) && !@last_key_state.include?(key)
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

      def to_sdl_key(key_code)
        return KEY_TABLE[key_code]
      end
    end
  end
end
