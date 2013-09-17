# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Font, 'フォントを表すクラス' do
  describe '.new' do
    given = 32
    context "大きさ(#{given.inspect})を指定した場合" do
      subject { described_class.new(given) }

      its(:size) { should eq(given) }
    end
  end

  shared_context '#get_width' do
    let(:font) { described_class.new(32) }
    let(:method) { :get_width }

    subject { font.send(method, 'やあ') }

    it { should be_kind_of(Integer) }

    it 'SDL::TTF#text_size(\'やあ\')を呼び出す' do
      expect_any_instance_of(SDL::TTF)
        .to receive(:text_size).with('やあ').once.and_return([62, 32])
      subject
    end
  end

  describe '#get_width', '文字列の描画幅を返す' do
    include_context '#get_width'

    describe 'alias' do
      describe '#getWidth' do
        it_behaves_like '#get_width' do
          let(:method) { :getWidth }
        end
      end
    end
  end
end
