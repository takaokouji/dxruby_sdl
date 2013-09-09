# -*- coding: utf-8 -*-
require 'dxruby'

c = 255
r = 1

font = Font.new(32)
i = Image.new(640, 480)

Window.loop do
  c -= Input.x
  if c > 255
    c = 255
  end
  if c < 0
    c = 0
  end

  r -= Input.y
  if r > 20
    r = 20
  end
  if r < 1
    r = 1
  end

  Window.drawFont(0, 0, "C:#{c} R:#{r}", font)

  if  Input.mouseDown?(M_LBUTTON)
    x = Input.mousePosX
    y = Input.mousePosY
    i.circleFill(x, y, r, [c, c, c])
  end
  Window.draw(0, 0, i)
end
