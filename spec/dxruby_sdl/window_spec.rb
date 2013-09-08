# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Window do
  context 'デフォルトの設定の場合' do
    default = {
      width: 640,
      height: 480,
      background_color: [0, 0, 0],
    }

    let(:width) { default[:width] }
    let(:height) { default[:height] }
    let(:background_color) { default[:background_color] }

    describe '.loop', 'メインループ' do
      it "サイズが#{default[:width]}x#{default[:height]}、" \
        "背景がRGB(#{default[:background_color].join(", ")})の" \
        "ウィンドウを表示して、ESCキーを入力するまで待つ" do
        expect {
          DXRubySDL::Window.loop do
            SDL::Event.push(SDL::Event::Quit.new)
          end
        }.to raise_error(SystemExit)
      end
    end

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
        it '画像を描画する' do
          expect {
            path = File.expand_path('../../fixtures/logo.png', __FILE__)
            i = DXRubySDL::Image.load(path)
            DXRubySDL::Window.loop do
              DXRubySDL::Window.draw(0, 0, i)
              SDL::Event.push(SDL::Event::Quit.new)
            end
          }.to raise_error(SystemExit)
        end
      end
    end

    describe '.draw_font', '文字列を描画する' do
      context 'サイズのみを設定したフォントを指定した場合' do
        let!(:font) { DXRubySDL::Font.new(32) }
        let(:args) { [0, 0, 'やあ', font] }

        subject do
          expect {
            DXRubySDL::Window.loop do
              DXRubySDL::Window.draw_font(*args)
              SDL::Event.push(SDL::Event::Quit.new)
            end
          }.to raise_error(SystemExit)
        end

        it '文字列を描画する' do
          subject
        end

        hash = { color: [255, 0, 0] }
        context "第5引数に色(#{hash.inspect})を指定した場合" do
          let(:args) { [0, 0, 'やあ', font, hash] }

          it '文字列を描画する' do
            subject
          end
        end
      end
    end
  end
end
