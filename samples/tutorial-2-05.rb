# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/200953122575875.htm
require 'dxruby'

image = Image.load('data.png')  # data.pngを読み込む
x = 0
y = 0

Window.loop do
  x = x + Input.x  # x座標の更新
  y = y + Input.y  # y座標の更新

  Window.draw(x, y, image)  # data.pngを描画する
end
