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
      it "サイズが#{default[:width]}x#{default[:height]}、背景がRGB(#{default[:background_color].join(", ")})のウィンドウを表示して、ESCキーを入力するまで待つ" do
        expect {
          DXRubySDL::Window.loop do
            SDL::Event.push(SDL::Event::Quit.new)
          end
        }.to raise_error(SystemExit)
      end
    end
  end
end
