# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/2009610612281.htm
require 'dxruby'

image = Image.load('data.png')  # data.pngを読み込む

Window.loop do
  Window.draw(100, 100, image)  # data.pngを描画する
  if Input.keyPush?(K_ESCAPE) then  # Escキーで終了
    break
  end
end
