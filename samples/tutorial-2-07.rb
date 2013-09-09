# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/2009531233720546.htm
require 'dxruby'

image = Image.load('data.png')  # data.pngを読み込む

Window.loop do
  x = Input.mousePosX  # マウスカーソルのx座標
  y = Input.mousePosY  # マウスカーソルのy座標

  Window.draw(x, y, image)  # data.pngを描画する
end
