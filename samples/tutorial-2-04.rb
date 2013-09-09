# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/2009531224931296.htm
require 'dxruby'

baseimage = Image.load('data.png')  # data.pngを読み込む
image = baseimage.slice(0, 0, 20, 20)  # data.pngの(0, 0)から20*20pixel分だけ画像を切り出す

Window.loop do
  Window.draw(100, 100, image)  # data.pngの左上20pixel正方形を描画する
end
