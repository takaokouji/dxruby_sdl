# -*- coding: utf-8 -*-

module DXRubySDL
  class Sprite
    attr_accessor :x
    attr_accessor :y
    attr_accessor :image
    attr_accessor :z
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
      def check(o_sprites, d_sprites, shot = :shot, hit = :hit)
        res = false
        o_sprites = [o_sprites].flatten
        d_sprites = [d_sprites].flatten
        o_sprites.each do |o_sprite|
          d_sprites.each do |d_sprite|
            if o_sprite === d_sprite
              if o_sprite.respond_to?(shot) && shot
                o_sprite.send(shot, d_sprite)
              end
              if d_sprite.respond_to?(hit) && hit
                d_sprite.send(hit, o_sprite)
              end
              res = true
            end
          end
        end
        return res
      end

      def update(sprites)
        sprites.flatten.each do |s|
          if s.respond_to?(:update)
            s.update
          end
        end
      end

      def draw(sprites)
        sprites.flatten.each do |s|
          if s.respond_to?(:draw)
            s.draw
          end
        end
      end

      def clean(sprites)
        return [sprites].flatten.reject(&:vanished?)
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

      calc_center
    end

    def image=(val)
      @image = val
      calc_center
    end

    def draw
      if !@visible || vanished?
        return
      end
      [:target, :blend, :shader].each do |method|
        if send(method)
          raise NotImplementedError, "Sprite#draw with #{method}"
        end
      end
      options = {}
      if angle
        options[:angle] = angle
      end
      if scale_x
        options[:scale_x] = scale_x
      end
      if scale_y
        options[:scale_y] = scale_y
      end
      if center_x
        options[:center_x] = center_x
      end
      if center_y
        options[:center_y] = center_y
      end
      Window.draw_ex(x, y, image, options)
    end

    def ===(other)
      if !@collision_enable || vanished? ||
          !other.collision_enable || other.vanished? ||
          !other.image && !other.collision
        return false
      end
      return other.x + other.image.width > x && other.x < x + image.width &&
        other.y + other.image.height > y && other.y < y + image.height
    end

    def check(sprites)
      return [sprites].flatten.select { |s| self === s }
    end

    def vanish
      @vanished = true
    end

    def vanished?
      return @vanished
    end

    private

    def calc_center
      if @image
        @center_x = @image.width / 2
        @center_y = @image.height / 2
      else
        @center_x = 0
        @center_y = 0
      end
    end
  end
end
