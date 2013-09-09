# -*- coding: utf-8 -*-
# http://dxruby.sourceforge.jp/DXRubyReference/2009610590500.htm
require 'dxruby'

sound = Sound.new("sound.wav")  # sound.wav読み込み
bgm = Sound.new("bgm.mid")  # bgm.mid読み込み

bgm.play

Window.loop do
  if Input.keyPush?(K_Z) then  # Zキーで再生
    sound.play
  end
end
