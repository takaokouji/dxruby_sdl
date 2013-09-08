# -*- coding: utf-8 -*-

require 'singleton'

module DXRubySDL
  module Window
    # FPSTimer is copied from http://www.kmc.gr.jp/~ohai/fpstimer.rb.
    class FPSTimer
      include Singleton

      FPS_COUNT = 10

      attr_accessor :fps
      attr_reader :real_fps, :total_skip
      attr_reader :count_sleep
      # +fps+ is the number of frames per second that you want to keep,
      # +accurary+ is the accurary of sleep/SDL.delay in milisecond
      def initialize(fps = 60, accurary = 10, skip_limit = 15)
        @fps = fps
        @accurary = accurary / 1000.0
        @skip_limit = skip_limit
      end

      # reset timer, you should call just before starting loop
      def reset
        @old = get_ticks
        @skip = 0
        @real_fps = @fps
        @frame_count = 0
        @fps_old = @old
        @count_sleep = 0
        @total_skip = 0
      end

      # execute given block and wait
      def wait_frame
        now = get_ticks
        nxt = @old + (1.0 / @fps)
        if nxt > now
          yield
          @skip = 0
          wait(nxt)
          @old = nxt
        elsif @skip > @skip_limit
          # :nocov:
          yield
          @skip = 0
          @old = get_ticks
          # :nocov:
        else
          # :nocov:
          @skip += 1
          @total_skip += 1
          @old = nxt
          # :nocov:
        end

        calc_real_fps
      end

      private

      def wait(nxt)
        while nxt > get_ticks + @accurary
          sleep(@accurary - 0.005)
          @count_sleep += 1
        end

        while nxt > get_ticks
          # busy loop, do nothing
        end
      end

      def get_ticks
        SDL.getTicks / 1000.0
      end

      def calc_real_fps
        @frame_count += 1
        if @frame_count >= FPS_COUNT
          # :nocov:
          @frame_count = 0
          now = get_ticks
          @real_fps = FPS_COUNT / (now - @fps_old)
          @fps_old = now
          # :nocov:
        end
      end
    end
  end
end
