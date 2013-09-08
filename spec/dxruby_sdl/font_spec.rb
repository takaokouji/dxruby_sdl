# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Font, 'フォントを表すクラス' do
  describe '.new' do
    given = 32
    context "大きさ(#{given.inspect})を指定した場合" do
      subject { DXRubySDL::Font.new(given) }

      its(:size) { should eq(given) }
    end
  end
end
