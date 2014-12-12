# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Sprite, 'ゲームのキャラを扱う場合の基本となるクラス' do
  let(:image) { DXRubySDL::Image.load(fixture_path('logo.png')) }
  let(:sprite) { described_class.new(50, 150, image) }

  describe '.check' do
    def make_o_sprite(collision, discard = false)
      s = described_class.new(0, 0)
      allow(s).to receive(:===).and_return(collision)
      if discard
        allow(s).to receive(:shot).and_return(:discard)
      else
        allow(s).to receive(:shot)
      end
      return s
    end

    def make_d_sprite(discard = false)
      s = described_class.new(0, 0)
      if discard
        allow(s).to receive(:hit).and_return(:discard)
      else
        allow(s).to receive(:hit)
      end
      return s
    end

    let(:o_sprites) {
      Array.new(5) {
        make_o_sprite(true)
      }
    }
    let(:d_sprites) {
      Array.new(5) {
        make_d_sprite
      }
    }

    subject { described_class.check(o_sprites, d_sprites) }

    before do
      subject
    end

    shared_examples 'return' do |val|
      describe '戻り値' do
        if val
          it { should be_true }
        else
          it { should be_false }
        end
      end
    end

    context 'Spriteが衝突している場合' do
      context 'o_sprites引数がSpriteオブジェクトの場合' do
        let(:o_sprites) { make_o_sprite(true) }

        specify 'o_spritesに対して#shotが呼ばれる' do
          d_sprites.each do |d_sprite|
            expect(o_sprites).to have_received(:shot).with(d_sprite).once
          end
        end

        specify 'd_spritesの各要素に対して#hitが呼ばれる' do
          d_sprites.each do |d_sprite|
            expect(d_sprite).to have_received(:hit).with(o_sprites).once
          end
        end

        include_examples 'return', true
      end

      context 'd_sprites引数がSpriteオブジェクトの場合' do
        let(:d_sprites) { make_d_sprite }

        specify 'o_spritesに対して#shotが呼ばれる' do
          o_sprites.each do |o_sprite|
            expect(o_sprite).to have_received(:shot).with(d_sprites).once
          end
        end

        specify 'd_spritesに対して#hitが呼ばれる' do
          o_sprites.each do |o_sprite|
            expect(d_sprites).to have_received(:hit).with(o_sprite).once
          end
        end

        include_examples 'return', true
      end

      context 'o_sprites引数がSpriteオブジェクトの配列の場合' do
        specify 'o_spritesの各要素に対して#shotが呼ばれる' do
          o_sprites.each do |o_sprite|
            d_sprites.each do |d_sprite|
              expect(o_sprite).to have_received(:shot).with(d_sprite).once
            end
          end
        end

        specify 'd_spritesの各要素に対して#hitが呼ばれる' do
          d_sprites.each do |d_sprite|
            o_sprites.each do |o_sprite|
              expect(d_sprite).to have_received(:hit).with(o_sprite)
            end
          end
        end

        include_examples 'return', true
      end

      context 'o_sprites引数の#shotが:discardを返す場合' do
        let(:o_sprites) {
          Array.new(5) {
            make_o_sprite(true, true)
          }
        }

        specify 'o_spritesの各要素は#shotが1回だけ呼ばれる' do
          o_sprites.each.with_index do |o_sprite, i|
            d_sprites.each.with_index do |d_sprite, j|
              if i == j
                expect(o_sprite).to have_received(:shot).with(d_sprite).once
              else
                expect(o_sprite).not_to have_received(:shot).with(d_sprite)
              end
            end
          end
        end

        specify 'd_spritesの各要素は#hitが1回だけ呼ばれる' do
          o_sprites.each.with_index do |o_sprite, i|
            d_sprites.each.with_index do |d_sprite, j|
              if i == j
                expect(d_sprite).to have_received(:hit).with(o_sprite).once
              else
                expect(d_sprite).not_to have_received(:hit).with(o_sprite)
              end
            end
          end
        end

        include_examples 'return', true
      end

      context 'd_sprites引数の#hitが:discardを返す場合' do
        let(:d_sprites) {
          Array.new(5) {
            make_d_sprite(true)
          }
        }

        specify 'o_spritesの各要素は#shotが1回だけ呼ばれる' do
          o_sprites.each.with_index do |o_sprite, i|
            d_sprites.each.with_index do |d_sprite, j|
              if i == j
                expect(o_sprite).to have_received(:shot).with(d_sprite).once
              else
                expect(o_sprite).not_to have_received(:shot).with(d_sprite)
              end
            end
          end
        end

        specify 'd_spritesの各要素は#hitが1回だけ呼ばれる' do
          o_sprites.each.with_index do |o_sprite, i|
            d_sprites.each.with_index do |d_sprite, j|
              if i == j
                expect(d_sprite).to have_received(:hit).with(o_sprite).once
              else
                expect(d_sprite).not_to have_received(:hit).with(o_sprite)
              end
            end
          end
        end

        include_examples 'return', true
      end
    end

    context 'Spriteが衝突していない場合' do
      let(:o_sprites) {
        Array.new(5) {
          make_o_sprite(false)
        }
      }

      specify 'o_spritesの各要素に対してSprite#shotが呼ばれない' do
        o_sprites.each do |o_sprite|
          expect(o_sprite).not_to have_received(:shot)
        end
      end

      specify 'd_spritesの各要素に対してSprite#hitが呼ばれない' do
        d_sprites.each do |d_sprite|
          expect(d_sprite).not_to have_received(:hit)
        end
      end

      include_examples 'return', false
    end

    context 'o_sprites引数やd_sprites引数に' \
            'Spriteオブジェクト以外を指定した場合' do
      let(:o_sprites) {
        s = double('Some Object')
        allow(s).to receive(:===).and_return(true)
        allow(s).to receive(:shot)
        s
      }
      let(:d_sprites) {
        s = double('Some Object')
        allow(s).to receive(:hit)
        s
      }

      describe 'o_sprites引数' do
        it { expect(o_sprites).not_to have_received(:===) }
        it { expect(o_sprites).not_to have_received(:shot) }
      end

      describe 'd_sprites引数' do
        it { expect(d_sprites).not_to have_received(:hit) }
      end

      include_examples 'return', false
    end
  end

  shared_context '配列内のオブジェクトのメソッドの呼び出し' do |_method|
    describe ".#{_method}",
             "配列内のすべてのオブジェクトの#{_method}メソッドを呼び出す" do
      let(:method) { _method }

      subject do
        expect {
          described_class.send(method, ary)
        }.not_to raise_error
      end

      shared_context 'メソッドを呼び出す' do
        context "配列内のすべてのオブジェクトに#{_method}メソッドがある場合" do
          def make_sprite(i)
            s = double('Sprite')
            expect(s).to receive(method).once
            return s
          end

          specify "配列内のすべてのオブジェクトの#{_method}メソッドを" \
                  '1回呼び出す' do
            subject
          end
        end

        context "配列内のオブジェクトの一部に#{_method}メソッドがある場合" do
          def make_sprite(i)
            s = double('Sprite')
            if i.even?
              expect(s).to receive(method).once
            end
            return s
          end

          specify "配列内の一部のオブジェクトの#{_method}メソッドを" \
                  '1回呼び出す' do
            subject
          end
        end

        context "配列内のオブジェクトに#{_method}メソッドがない場合" do
          def make_sprite(i)
            return double('Sprite')
          end

          specify "配列内のすべてのオブジェクトの#{_method}メソッドを" \
                  '呼び出さない' do
            subject
          end
        end
      end

      context '引数がネストしていない配列の場合' do
        let(:ary) {
          5.times.map { |i|
            make_sprite(i)
          }
        }

        include_context 'メソッドを呼び出す'
      end

      context '引数がネストした配列の場合' do
        let(:ary) {
          Array.new(5) {
            5.times.map { |i|
              make_sprite(i)
            }
          }
        }

        include_context 'メソッドを呼び出す'
      end
    end
  end

  include_context '配列内のオブジェクトのメソッドの呼び出し', :update
  include_context '配列内のオブジェクトのメソッドの呼び出し', :draw

  describe '.clean',
           '配列内のすべてのオブジェクトのvanished?メソッドを呼び出し、' \
           'trueが返ってきた要素と、もともとnilだった要素を削除する' do
    subject {
      described_class.clean(ary)
      ary
    }

    shared_examples 'vanished?メソッドを呼び出す' do
      it '配列内のすべてのオブジェクトのvanished?メソッドを呼び出す' do
        subject
        ary.flatten.each do |s|
          expect(s).to have_received(:vanished?).once
        end
      end
    end

    context '引数がネストしていない配列の場合' do
      let(:ary) {
        5.times.map { |i|
          make_sprite(i)
        }
      }

      context 'すべてのvanished?がtrueを返す場合' do
        def make_sprite(i)
          s = double('Sprite', index: i)
          allow(s).to receive(:vanished?).and_return(true)
          return s
        end

        include_examples 'vanished?メソッドを呼び出す'

        it { should be_empty }
      end

      context '一部のvanished?がtrueを返す場合' do
        def make_sprite(i)
          s = double('Sprite', index: i)
          if i.even?
            allow(s).to receive(:vanished?).and_return(true)
          else
            allow(s).to receive(:vanished?).and_return(false)
          end
          return s
        end

        include_examples 'vanished?メソッドを呼び出す'

        it 'vanished?がtrueのものが取り除かれた配列を返す' do
          expect(subject.map(&:index)).to eq([1, 3])
        end
      end

      context '一部がnil、それ以外のvanished?がfalseを返す場合' do
        def make_sprite(i)
          if i.even?
            s = double('Sprite', index: i)
            allow(s).to receive(:vanished?).and_return(false)
            return s
          else
            return nil
          end
        end

        it '配列内のnilではないオブジェクトのvanished?メソッドを呼び出す' do
          expect {
            subject
          }.not_to raise_error

          ary.flatten.each do |s|
            if !s.nil?
              expect(s).to have_received(:vanished?).once
            end
          end
        end

        it 'nilのものが取り除かれた配列を返す' do
          expect(subject.map(&:index)).to eq([0, 2, 4])
        end
      end

      context 'すべてのvanished?がfalseを返す場合' do
        def make_sprite(i)
          s = double('Sprite', index: i)
          allow(s).to receive(:vanished?).and_return(false)
          return s
        end

        include_examples 'vanished?メソッドを呼び出す'

        it 'なにも取り除かない' do
          expect(subject.map(&:index)).to eq([0, 1, 2, 3, 4])
        end
      end
    end

    context '引数がネストした配列の場合' do
      let(:ary) {
        Array.new(5) {
          5.times.map { |i|
            make_sprite(i)
          }
        }
      }

      context 'すべてのvanished?がtrueを返す場合' do
        def make_sprite(i)
          s = double('Sprite', index: i)
          allow(s).to receive(:vanished?).and_return(true)
          return s
        end

        include_examples 'vanished?メソッドを呼び出す'

        it { expect(subject).to eq(Array.new(5) { [] }) }
      end

      context '一部のvanished?がtrueを返す場合' do
        def make_sprite(i)
          s = double('Sprite', index: i)
          if i.even?
            allow(s).to receive(:vanished?).and_return(true)
          else
            allow(s).to receive(:vanished?).and_return(false)
          end
          return s
        end

        include_examples 'vanished?メソッドを呼び出す'

        it 'vanished?がtrueのものが取り除かれた配列を返す' do
          expect(subject.map { |i| i.map(&:index) })
            .to eq(Array.new(5) { [1, 3] })
        end
      end

      context '一部がnil、それ以外のvanished?がfalseを返す場合' do
        def make_sprite(i)
          if i.even?
            s = double('Sprite', index: i)
            allow(s).to receive(:vanished?).and_return(false)
            return s
          else
            return nil
          end
        end

        it '配列内のnilではないオブジェクトのvanished?メソッドを呼び出す' do
          expect {
            subject
          }.not_to raise_error

          ary.flatten.each do |s|
            if !s.nil?
              expect(s).to have_received(:vanished?).once
            end
          end
        end

        it 'nilのものが取り除かれた配列を返す' do
          expect(subject.map { |i| i.map(&:index) })
            .to eq(Array.new(5) { [0, 2, 4] })
        end
      end

      context 'すべてのvanished?がfalseを返す場合' do
        def make_sprite(i)
          s = double('Sprite', index: i)
          allow(s).to receive(:vanished?).and_return(false)
          return s
        end

        include_examples 'vanished?メソッドを呼び出す'

        it 'なにも取り除かない' do
          expect(subject.map { |i| i.map(&:index) })
            .to eq(Array.new(5) { [0, 1, 2, 3, 4] })
        end
      end
    end
  end

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

  describe '#check' do
    let(:others) { [1, 2, 3, 4, 5] }

    subject { sprite.check(others) }

    before do
      allow(sprite).to receive(:===) { |other|
                         if [1, 3, 5].include?(other)
                           true
                         else
                           false
                         end
                       }
    end

    it { should include(1, 3, 5) }
    it { should have(3).items }
  end

  describe '#draw' do
    subject do
      expect {
        DXRubySDL::Window.loop do
          sprite.draw
          SDL::Event.push(SDL::Event::Quit.new)
        end
      }.to raise_error(SystemExit)
    end

    context '左右反転' do
      before do
        sprite.scale_x = -1.0
      end

      it '描画できる' do
        subject
      end
    end
  end
end
