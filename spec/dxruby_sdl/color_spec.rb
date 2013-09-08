# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Color, 'カラーを変換するモジュール' do
  describe '#to_sdl_color', 'DXRubyのカラー情報をSDLのカラー情報に変換する' do
    subject { described_class.to_sdl_color(color) }

    expected = [0, 125, 255]
    context "引数が3つの要素の配列(#{expected.inspect})の場合" do
      let(:color) { [0, 125, 255] }

      it { should be(color) }
    end

    context "引数が4つの要素の配列で最初の3つが(#{expected.inspect})の場合" do
      let(:color) { expected + [0] }

      it { should eq(expected) }
    end
  end

  describe '#to_sdl_alpha', 'カラー情報からアルファ値を抽出する' do
    subject { described_class.to_sdl_alpha(color) }

    context '引数が3つの要素の配列の場合' do
      let(:color) { [0, 125, 255] }

      it '常に255を返す' do
        should eq(255)
      end
    end

    [0, 125, 255].each do |expected|
      context "引数が4つの要素の配列で最後の値が#{expected}の場合" do
        let(:color) { [0, 125, 255, expected] }

        it { should eq(expected) }
      end
    end
  end
end
