# -*- coding: utf-8 -*-

module DXRubySDL
  class Sound
    @sdl_mixer_openend = false

    def initialize(filename)
      if !self.class.instance_variable_get('@sdl_mixer_openend')
        SDL::Mixer.open
        SDL::Mixer.allocate_channels(2)
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
        @last_played_channel = nil
      end

      def play
        @last_played_channel = SDL::Mixer.play_channel(-1, @wave, 0)
      rescue SDL::Error => e
        if /No free channels available/ =~ e.message
          SDL::Mixer.halt(@last_played_channel == 0 ? 1 : 0)
          retry
        end
      end
    end
    private_constant :Wave
  end
end
