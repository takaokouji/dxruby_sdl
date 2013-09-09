# -*- coding: utf-8 -*-

module DXRubySDL
  class Sound
    @sdl_mixer_openend = false

    def initialize(filename)
      if !self.class.instance_variable_get('@sdl_mixer_openend')
        SDL::Mixer.open
        self.class.instance_variable_set('@sdl_mixer_openend', true)
      end
      if /\.mid$/ =~ filename
        @sound = Music.new(filename)
      else
        @sound = Wave.new(filename)
      end
    end

    def play
      @sound.play
    end

    private

    class Music
      def initialize(filename)
        @music = SDL::Mixer::Music.load(filename)
      end

      def play
        SDL::Mixer.play_music(@music, -1)
      end
    end
    private_constant :Music

    class Wave
      def initialize(filename)
        @wave = SDL::Mixer::Wave.load(filename)
      end

      def play
        SDL::Mixer.play_channel(-1, @wave, 0)
      end
    end
    private_constant :Wave
  end
end
