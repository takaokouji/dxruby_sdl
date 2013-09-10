# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::SoundEffect, '効果音を生成するクラス' do
  let(:sound_effect) {
    v = 80
    described_class.new(50, DXRubySDL::WAVE_RECT, 1000) {
      v = v - 4 if v > 0
      [220, v]
    }
  }

  describe '.new' do
    it '呼び出すことができる' do
      expect { sound_effect }.not_to raise_error
    end
  end

  describe '#add' do
    it '呼び出すことができる' do
      expect {
        v = 80
        sound_effect.add(DXRubySDL::WAVE_RECT, 1000) {
          v = v - 4 if v > 0
          [440, v]
        }
      }.not_to raise_error
    end
  end

  describe '#play' do
    it '呼び出すことができる' do
      expect { sound_effect.play }.not_to raise_error
    end
  end

  describe '#stop' do
    it '呼び出すことができる' do
      expect { sound_effect.stop }.not_to raise_error
    end
  end
end
