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
        SDL.init(SDL::INIT_EVERYTHING)
        screen = SDL.set_video_mode(width, height, 16, SDL::SWSURFACE)
        screen.fill_rect(0, 0, width, height, background_color)
        screen.update_rect(0, 0, 0, 0)
        begin
          loop do  
            while (event = SDL::Event2.poll)
              case event
              when SDL::Event2::Quit
                exit
              end
            end
          end
        rescue SystemExit
        end
      end
    end
  end
end
