# -*- coding: utf-8 -*-

module DXRubySDL
  class SoundEffect
    def initialize(time, wavetype = WAVE_RECT, resolution = 1000)
      @time = time

      @time.times { yield }
    end

    def add(wavetype = WAVE_RECT, resolution = 1000)
      @time.times { yield }
    end

    def play
    end

    def stop
    end
  end
end
