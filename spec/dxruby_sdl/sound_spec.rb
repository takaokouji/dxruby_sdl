# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Sound, '音を表すクラス' do
  describe '.new' do
    shared_context '.new' do
      subject { DXRubySDL::Sound.new(fixture_path(filename)) }

      it '呼び出すことができる' do
        subject
      end
    end

    context 'WAVE形式のファイルの場合' do
      let(:filename) { 'sound.wav' }

      include_context '.new'
    end

    context 'MIDI形式のファイルの場合' do
      let(:filename) { 'bgm.mid' }

      include_context '.new'
    end
  end
end
