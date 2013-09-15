# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Sprite, 'ゲームのキャラを扱う場合の基本となるクラス' do
  let(:image) { DXRubySDL::Image.load(fixture_path('logo.png')) }

  let(:sprite) { described_class.new(50, 150, image) }

  describe '.new' do
    subject { sprite }

    shared_examples 'default' do
      its(:z) { should be_nil }
      its(:angle) { should be_nil }
      its(:scale_x) { should be_nil }
      its(:scale_y) { should be_nil }
      its(:alpha) { should be_nil }
      its(:blend) { should be_nil }
      its(:shader) { should be_nil }
    end

    its(:x) { should eq(50) }
    its(:y) { should eq(150) }
    its(:image) { should eq(image) }
    include_examples 'default'

    context 'image引数を省略した場合' do
      subject { described_class.new(50, 150) }

      its(:x) { should eq(50) }
      its(:y) { should eq(150) }
      its(:image) { should be_nil }
      include_examples 'default'
    end

    context 'y, image引数を省略した場合' do
      subject { described_class.new(50) }

      its(:x) { should eq(50) }
      its(:y) { should eq(0) }
      its(:z) { should eq(0) }
      include_examples 'default'
    end

    context 'x, y, image引数を省略した場合' do
      subject { described_class.new }

      its(:x) { should eq(0) }
      its(:y) { should eq(0) }
      its(:image) { should be_nil }
      include_examples 'default'
    end
  end

  describe '.x=' do
    [-1, 0, 1, 100, 639, 640, 641].each do |val|
      context "#{val}を指定した場合" do
        subject {
          sprite.x = val
          sprite.x
        }

        it { should eq(val) }
      end
    end
  end

  describe '.y=' do
    [-1, 0, 1, 100, 479, 480, 481].each do |val|
      context "#{val}を指定した場合" do
        subject {
          sprite.y = val
          sprite.y
        }

        it { should eq(val) }
      end
    end
  end

  describe '.z=' do
    [-1, 0, 1, 99, 100, 101].each do |val|
      context "#{val}を指定した場合" do
        subject {
          sprite.z = val
          sprite.z
        }

        it { should eq(val) }
      end
    end
  end
end
