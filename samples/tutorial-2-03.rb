# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/2009531224032156.htm
require 'dxruby'

image = Image.loadToArray('data.png', 2, 2)  # data.pngを読み込んで、横２つ、縦２つに分割する

Window.loop do
  Window.draw(100, 100, image[0])  # data.pngの左上を描画する
  Window.draw(150, 100, image[1])  # data.pngの右上を描画する
  Window.draw(100, 150, image[2])  # data.pngの左下を描画する
  Window.draw(150, 150, image[3])  # data.pngの右下を描画する
end
