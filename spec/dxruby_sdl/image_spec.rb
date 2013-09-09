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

  shared_context '.load_tiles' do
    context '画像の幅と高さが割り切れる(518x232、xcountが2、ycountが4)場合' do
      let(:xcount) { 2 }
      let(:ycount) { 4 }

      subject {
        DXRubySDL::Image.load_tiles(fixture_path('logo.png'),
                                    xcount, ycount)
      }

      its(:length) { should eq(xcount * ycount) }

      it '各オブジェクトの幅はxcount(2)等分したものである' do
        subject.each do |image|
          expect(image.width).to eq(518 / xcount)
        end
      end

      it '各オブジェクトの高さはycount(4)等分したものである' do
        subject.each do |image|
          expect(image.height).to eq(232 / ycount)
        end
      end
    end
  end

  describe '.load_tiles',
           '画像を読み込み、横・縦がそれぞれxcount個、' \
           'ycount個であると仮定して自動で分割し、' \
           '左上から右に向かう順序でImageオブジェクトの配列を生成して返す' do
    include_context '.load_tiles'

    describe 'alias' do
      describe '.loadTiles' do
        it_behaves_like '.load_tiles' do
          subject {
            DXRubySDL::Image.loadTiles(fixture_path('logo.png'),
                                       xcount, ycount)
          }
        end
      end

      describe '.load_to_array' do
        it_behaves_like '.load_tiles' do
          subject {
            DXRubySDL::Image.load_to_array(fixture_path('logo.png'),
                                           xcount, ycount)
          }
        end
      end

      describe '.loadToArray' do
        it_behaves_like '.load_tiles' do
          subject {
            DXRubySDL::Image.loadToArray(fixture_path('logo.png'),
                                         xcount, ycount)
          }
        end
      end
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

  describe '#box' do
    it '呼び出すことができる' do
      image.box(0, 0, 100, 100, [255, 255, 255])
    end
  end
end
