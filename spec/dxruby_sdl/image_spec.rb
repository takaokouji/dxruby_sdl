# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Image, '画像を表すクラス' do
  let(:image) { DXRubySDL::Image.new(640, 480) }

  describe '.new' do
    context '幅と高さを指定した場合' do
      subject { image }

      its(:width) { should eq(640) }
      its(:height) { should eq(480) }
    end
  end

  describe '.load' do
    subject {
      path = File.expand_path("../../fixtures/#{filename}", __FILE__)
      DXRubySDL::Image.load(path)
    }
    
    context 'PNG形式のファイルの場合' do
      let(:filename) { 'logo.png' }

      its(:width) { should eq(518) }
      its(:height) { should eq(232) }
    end

    context 'JPG形式のファイルの場合' do
      let(:filename) { 'logo.jpg' }

      its(:width) { should eq(518) }
      its(:height) { should eq(232) }
    end
  end

  describe '#line' do
    it '呼び出すことができる' do
      image.line(0, 0, 100, 100, [255, 255, 255])
    end
  end

  describe '#circle' do
    it '呼び出すことができる' do
      image.circle(50, 50, 25, [255, 255, 255])
    end
  end
end
