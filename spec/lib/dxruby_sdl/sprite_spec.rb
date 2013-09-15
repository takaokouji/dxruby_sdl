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

  {
    x: [-1, 0, 1, 100, 639, 640, 641],
    y: [-1, 0, 1, 100, 479, 480, 481],
    z: [-1, 0, 1, 99, 100, 101],
    angle: [0, 90, 180, 260, 360],
    scale_x: [10.0, 1.0, 0.5, 0, -0.5, -1.0, -10.0],
    scale_y: [10.0, 1.0, 0.5, 0, -0.5, -1.0, -10.0],
    center_x: [-1, 0, 1, 100, 639, 640, 641],
    center_y: [-1, 0, 1, 100, 479, 480, 481],
    alpha: [0, 1, 254, 255],
    blend: [:alpha, :none, :add, :add2, :sub],
    shader: [:shader],
    image: [DXRubySDL::Image.load(fixture_path('logo.png'))],
    target: [:render_target1, :render_target2],
    collision: [1, [0, 0, 639, 439]],
    collision_sync: [true, false],
    collision_enable: [true, false],
    visible: [true, false],
  }.each do |method, vals|
    describe "##{method}=" do
      vals.each do |val|
        context "#{val.inspect}を指定した場合" do
          subject {
            sprite.send("#{method}=".to_sym, val)
            sprite.send(method)
          }

          it { should eq(val) }
        end
      end
    end
  end

  describe '#vanish' do
    describe 'レシーバ' do
      subject { sprite }

      context '呼び出す前' do
        its(:vanished?) { should be_false }
      end

      context '呼び出した後' do
        before do
          sprite.vanish
        end

        its(:vanished?) { should be_true }
      end
    end
  end

  describe '#vanished?' do
    subject { sprite.vanished? }

    context 'Spriteが有効な場合' do
      it { should be_false }
    end

    context 'vanishを呼び出してSpriteを無効化している場合' do
      before { sprite.vanish }

      it { should be_true }
    end
  end
end

