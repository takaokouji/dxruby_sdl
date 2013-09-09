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
  end

  describe '.fps=', 'FPSを設定する' do
    context '15に設定した場合' do
      let(:fps) { 15 }

      before do
        DXRubySDL::Window.fps = fps
      end

      describe 'DXRubySDL::Window::FPSTimer.instance' do
        subject { DXRubySDL::Window::FPSTimer.instance }

        its(:fps) { should eq(fps) }
      end
    end
  end

  shared_context '.draw_font' do
    context 'サイズのみを設定したフォントを指定した場合' do
      let!(:font) { DXRubySDL::Font.new(32) }
      let(:args) { [0, 0, 'やあ', font] }

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

  describe '.draw_font', '文字列を描画する' do
    include_context '.draw_font'

    subject do
      expect {
        DXRubySDL::Window.loop do
          DXRubySDL::Window.draw_font(*args)
          SDL::Event.push(SDL::Event::Quit.new)
        end
      }.to raise_error(SystemExit)
    end

    describe 'alias' do
      describe '.drawFont' do
        subject do
          expect {
            DXRubySDL::Window.loop do
              DXRubySDL::Window.drawFont(*args)
              SDL::Event.push(SDL::Event::Quit.new)
            end
          }.to raise_error(SystemExit)
        end

        it_should_behave_like '.draw_font'
      end
    end
  end
end
