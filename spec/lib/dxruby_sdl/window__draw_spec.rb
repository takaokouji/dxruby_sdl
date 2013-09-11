# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Window do
  describe '.draw', 'Imageオブジェクトを描画する' do
    subject do
      expect {
        DXRubySDL::Window.loop do
          DXRubySDL::Window.draw(0, 0, image)
          SDL::Event.push(SDL::Event::Quit.new)
        end
      }.to raise_error(SystemExit)
    end

    context '(0, 0)-(100,100)の白い線を描いたImageオブジェクトを指定した場合' do
      let!(:image) {
        i = DXRubySDL::Image.new(640, 480)
        i.line(0, 0, 100, 100, [255, 255, 255])
        i
      }

      it '白い線を描画する' do
        subject
      end
    end

    context '(0, 0)-(100,100)の矩形を描いたImageオブジェクトを指定した場合' do
      let!(:image) {
        i = DXRubySDL::Image.new(640, 480)
        i.box(0, 0, 100, 100, [255, 255, 255])
        i
      }

      it '矩形を描画する' do
        subject
      end
    end

    context '(50, 50)、半径25の円を描いたImageオブジェクトを指定した場合' do
      let!(:image) {
        i = DXRubySDL::Image.new(640, 480)
        i.circle(50, 50, 25, [255, 255, 255])
        i
      }

      it '円を描画する' do
        subject
      end
    end

    context '画像を読み込んだImageオブジェクトを指定した場合' do
      let!(:image) {
        DXRubySDL::Image.load(fixture_path('logo.png'))
      }

      it '画像を描画する' do
        subject
      end
    end

    context '画像を分割して読み込んだImageオブジェクトを指定した場合' do
      let!(:images) {
        DXRubySDL::Image.load_tiles(fixture_path('logo.png'), 2, 4)
      }

      specify '画像を描画する' do
        expect {
          DXRubySDL::Window.loop do
            margin = 64
            i = 0
            4.times do |y|
              2.times do |x|
                DXRubySDL::Window.draw(x * (images[i].width + margin),
                                       y * (images[i].height + margin),
                                       images[i])
                i += 1
              end
            end
            SDL::Event.push(SDL::Event::Quit.new)
          end
        }.to raise_error(SystemExit)
      end
    end
  end
end
