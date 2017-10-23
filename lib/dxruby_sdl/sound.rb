# -*- coding: utf-8 -*-

require 'forwardable'

module DXRubySDL
  class Sound
    extend Forwardable

    module Common
      MAX_DXRUBY_VOLUME = 255
      private_constant :MAX_DXRUBY_VOLUME
      MAX_SDL_VOLUME = 128
      private_constant :MAX_SDL_VOLUME

      def dxruby_volume_to_sdl_volume(volume)
        (volume * MAX_SDL_VOLUME.to_f / MAX_DXRUBY_VOLUME).round
      end
    end

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

    def_delegators :@sound, :play, :set_volume, :stop

    alias_method :setVolume, :set_volume

    private

    class Music
      include Common

      def initialize(filename)
        @music = SDL::Mixer::Music.load(filename)
      end

      def play
        SDL::Mixer.play_music(@music, -1)
      end

      def set_volume(volume, time = 0)
        if time > 0
          raise NotImplementedError, 'Sound#set_volume(volume, time != 0)'
        end
        @music.set_volume_music(dxruby_volume_to_sdl_volume(volume))
      end

      def stop
        SDL::Mixer.halt_music
      end
    end
    private_constant :Music

    class Wave
      include Common
      extend Forwardable

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

      def set_volume(volume, time = 0)
        if time > 0
          raise NotImplementedError, 'Sound#set_volume(volume, time != 0)'
        end
        @wave.set_volume(dxruby_volume_to_sdl_volume(volume))
      end

      def stop
        SDL::Mixer.halt(@last_played_channel) if @last_played_channel
      end
    end
    private_constant :Wave
  end
end
