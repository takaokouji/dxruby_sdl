# -*- coding: utf-8 -*-

module DXRubySDL
  class Sprite
    attr_accessor :x
    attr_accessor :y
    attr_reader :image
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
        o_sprites = [o_sprites].flatten.select { |s| s.is_a?(self) }
        d_sprites = [d_sprites].flatten.select { |s| s.is_a?(self) }
        discards = []
        o_sprites.each do |o_sprite|
          if discards.include?(o_sprite)
            next
          end
          d_sprites.each do |d_sprite|
            if discards.include?(o_sprite)
              break
            end
            if discards.include?(d_sprite)
              next
            end
            if o_sprite === d_sprite
              res = true
              discard = false
              if o_sprite.respond_to?(shot) && shot
                if o_sprite.send(shot, d_sprite) == :discard
                  discard = true
                end
              end
              if d_sprite.respond_to?(hit) && hit
                if d_sprite.send(hit, o_sprite) == :discard
                  discard = true
                end
              end
              if discard
                discards << o_sprite
                discards << d_sprite
              end
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
      if @collision_enable && @collision
        x, y, width, height =
          @collision[0] + @x, @collision[1] + @y, @collision[2], @collision[3]
      else
        x, y, width, height =
          @x, @y, @image.width, @image.height
      end
      if other.collision_enable && other.collision
        other_x, other_y, other_width, other_height =
          other.collision
      else
        other_x, other_y, other_width, other_height =
          other.x, other.y, other.image.width, other.image.height
      end
      return other_x + other_width > x && other_x < x + width &&
        other_y + other_height > y && other_y < y + height
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
