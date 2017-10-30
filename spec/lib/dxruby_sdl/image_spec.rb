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
    subject { DXRubySDL::Image.load(fixture_path(filename)) }

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
    subject {
      DXRubySDL::Image.load_tiles(fixture_path('logo.png'), xcount, ycount)
    }

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

  describe '#slice' do
    let(:image) { DXRubySDL::Image.load(fixture_path('logo.png')) }

    subject { image.slice(100, 100, 20, 40) }

    before do
      SDL::Surface.auto_lock_on
    end

    after do
      SDL::Surface.auto_lock_off
    end

    its(:width) { should eq(20) }
    its(:height) { should eq(40) }
    it { should be_instance_of(DXRubySDL::Image) }
    it '各ピクセルデータが正しい' do
      expect(subject._surface.pixels)
        .to eq(image._surface.copy_rect(100, 100, 20, 40).pixels)
    end
  end

  shared_context 'draw methods' do
    it '呼び出すことができる' do
      subject
    end

    it '戻り値はレシーバである' do
      expect(subject).to eq(image)
    end

    context 'auto_lockを有効にした場合' do
      before do
        SDL::Surface.auto_lock_on
      end

      after do
        SDL::Surface.auto_lock_off
      end

      it '呼び出すことができる' do
        subject
      end

      it '戻り値はレシーバである' do
        expect(subject).to eq(image)
      end
    end
  end

  describe '#line' do
    subject { image.line(0, 0, 100, 100, [255, 255, 255]) }

    include_context 'draw methods'
  end

  describe '#circle' do
    subject { image.circle(50, 50, 25, [255, 255, 255]) }

    include_context 'draw methods'
  end

  shared_context '#circle_fill' do
    include_context 'draw methods'
  end

  describe '#circle_fill' do
    subject { image.circle_fill(50, 50, 25, [255, 255, 255]) }

    include_context '#circle_fill'

    describe 'alias' do
      describe '#circleFill' do
        it_behaves_like '#circle_fill' do
          subject { image.circleFill(50, 50, 25, [255, 255, 255]) }
        end
      end
    end
  end

  describe '#box' do
    subject { image.box(0, 0, 100, 100, [255, 255, 255]) }

    include_context 'draw methods'
  end

  shared_context '#box_fill' do
    include_context 'draw methods'
  end

  describe '#box_fill' do
    subject { image.box_fill(0, 0, 100, 100, [255, 255, 255]) }

    include_context '#box_fill'

    describe 'alias' do
      describe '#boxFill' do
        it_behaves_like '#box_fill' do
          subject { image.boxFill(0, 0, 100, 100, [255, 255, 255]) }
        end
      end
    end
  end

  shared_context 'Source and Destination Images' do
    let(:source_image) { DXRubySDL::Image.new(640, 480) }
    let(:dest_image) { DXRubySDL::Image.new(640, 480) }
  end

  describe '#draw' do
    context 'nothing argumet' do
      include_context 'Source and Destination Images'

      subject { source_image.draw(0, 0, dest_image) }

      before do
        allow(SDL).to receive(:blitSurface)
        subject
      end

      describe SDL do
        it { expect(SDL).to have_received(:blitSurface).with( dest_image._surface, 0, 0, dest_image.width, dest_image.height, source_image._surface, 0, 0).once }
      end
    end

    context 'Specify argument' do
      include_context 'Source and Destination Images'

      subject { source_image.draw(0, 0, dest_image, 100, 200, 300, 400) }

      before do
        allow(SDL).to receive(:blitSurface)
        subject
      end

      describe SDL do
        it { expect(SDL).to have_received(:blitSurface).with(dest_image._surface, 100, 200, 300, 400, source_image._surface, 0, 0).once }
      end
    end
  end

  shared_context '#draw_font' do
    let!(:font) { DXRubySDL::Font.new(32) }
    let(:args) { [0, 0, 'やあ', font] }

    include_context 'draw methods'

    context '引数が空文字列の場合' do
      let(:args) { [0, 0, '', font] }

      it 'なにもしない' do
        expect { subject }.not_to raise_error
      end
    end

    context '引数が複数行の場合' do
      let(:args) { [0, 0, "やあ\n\nこんにちは\n\nHello\n", font] }

      it 'なにもしない' do
        expect { subject }.not_to raise_error
      end
    end

    color = [255, 0, 0]
    context "第5引数の色(#{color.inspect})を指定した場合" do
      let(:args) { [0, 0, 'やあ', font, color] }

      it '文字列を描画する' do
        subject
      end
    end
  end

  describe '#draw_font' do
    subject { image.draw_font(*args) }

    include_context '#draw_font'

    describe 'alias' do
      describe '#drawFont' do
        it_behaves_like '#draw_font' do
          subject { image.drawFont(*args) }
        end
      end
    end
  end
end
