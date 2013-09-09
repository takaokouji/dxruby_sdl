# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/200953123211781.htm
require 'dxruby'

image = Image.load('data.png')  # data.pngを読み込む
x = 0
y = 0
dx = 0
dy = 0

Window.loop do
  dx = Input.x  # x座標の移動量
  dy = Input.y  # y座標の移動量

  if Input.padDown?(P_BUTTON0) # Zキーかパッドのボタン０を押しているか判定
    dx = dx * 2
    dy = dy * 2
  end

  x = x + dx
  y = y + dy

  Window.draw(x, y, image)  # data.pngを描画する
end
