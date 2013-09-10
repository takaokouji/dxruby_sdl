# -*- coding: utf-8 -*-

module DXRubySDL
  class Sprite
    attr_accessor :x
    attr_accessor :y
    attr_accessor :image
    attr_accessor :angle
    attr_accessor :scale_x
    attr_accessor :scale_y
    attr_accessor :center_x
    attr_accessor :center_y
    attr_accessor :alpha
    attr_accessor :blend
    attr_accessor :shader
    attr_accessor :target
    attr_accessor :collision
    attr_accessor :collision_enable
    attr_accessor :collision_sync
    attr_accessor :visible

    class << self
      def check(o, d, shot = :shot, hit = :hit)
      end

      def update(ary)
      end

      def draw(ary)
      end

      def clean(ary)
      end
    end

    def initialize(x = 0, y = 0, image = nil)
      @x = x
      @y = y
      @image = image

      @collision_enable = true
      @collision_sync = true
      @visible = true
      @vanished = false
    end

    def draw
    end

    def ===(other)
      return true
    end

    def check(s)
      return []
    end

    def vanish
      @vanished = true
    end

    def vanished?
      return @vanished
    end
  end
end
