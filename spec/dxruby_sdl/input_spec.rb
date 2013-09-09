# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Input,
         'キーボード・ゲームパッド・マウスの入力を扱うモジュール' do
  def push_key(*keys)
    allow(SDL::Key).to receive(:press?) { |key|
                         keys.include?(key) ? true : false
                       }
  end

  shared_context 'push_key' do
    let(:_keys) { [] }

    before do
      allow(SDL::Key).to receive(:scan)
      push_key(*_keys)
    end
  end

  describe '.x' do
    include_context 'push_key'

    subject { described_class.x }

    context '左カーソルが押されている場合' do
      let(:_keys) { SDL::Key::LEFT }

      it { should eq(-1) }
    end

    context '右カーソルが押されている場合' do
      let(:_keys) { SDL::Key::RIGHT }

      it { should eq(1) }
    end

    context '左・右カーソルが両方とも押されている場合' do
      let(:_keys) { [SDL::Key::LEFT, SDL::Key::RIGHT] }

      it { should eq(0) }
    end

    context '左・右カーソルのどちらも押されていない場合' do
      it { should eq(0) }
    end
  end

  describe '.y' do
    include_context 'push_key'

    subject { described_class.y }

    context '上カーソルが押されている場合' do
      let(:_keys) { SDL::Key::UP }

      it { should eq(-1) }
    end

    context '下カーソルが押されている場合' do
      let(:_keys) { SDL::Key::DOWN }

      it { should eq(1) }
    end

    context '上・下カーソルが両方とも押されている場合' do
      let(:_keys) { [SDL::Key::UP, SDL::Key::DOWN] }

      it { should eq(0) }
    end

    context '上・下カーソルのどちらも押されていない場合' do
      it { should eq(0) }
    end
  end
end
