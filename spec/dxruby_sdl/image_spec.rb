# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Image, '画像を表すクラス' do
  describe '.new' do
    context '幅と高さを指定した場合' do
      subject { DXRubySDL::Image.new(640, 480) }

      its(:width) { should eq(640) }
      its(:height) { should eq(480) }
    end
  end
end
