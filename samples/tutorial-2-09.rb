# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/2009610505893.htm
require 'dxruby'

font = Font.new(32)  # 第２引数を省略するとＭＳ Pゴシックになります

Window.loop do
  Window.drawFont(100, 100, "ふぉんと", font)  # "ふぉんと"を描画する
end
