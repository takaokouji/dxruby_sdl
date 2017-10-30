# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Sound, '音を表すクラス' do
  shared_context 'WAVE file', wave: true do
    let(:path) { fixture_path('sound.wav') }
    let(:sound) { DXRubySDL::Sound.new(path) }
  end

  shared_context 'MIDI file', midi: true do
    let(:path) { fixture_path('bgm.mid') }
    let(:sound) { DXRubySDL::Sound.new(path) }
  end

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

  describe '#play' do
    context 'WAVE file', wave: true do
      subject { sound.play }

      it 'SDL::Mixer.play_channelを呼び出す' do
        wave =
          sound.instance_variable_get('@sound').instance_variable_get('@wave')
        expect(SDL::Mixer).to receive(:play_channel).with(-1, wave, 0)
        subject
      end

      context '3回連続で呼び出した場合' do
        before do
          wave = sound.instance_variable_get('@sound')
            .instance_variable_get('@wave')
          count = 0
          expect(SDL::Mixer)
            .to receive(:play_channel).with(-1, wave, 0).exactly(4).times {
                  count += 1
                  if count == 3
                    count = 0
                    raise SDL::Error.new('couldn\'t play wave:' \
                                         ' No free channels available')
                  end
                  (count - 1) % 2
                }
          expect(SDL::Mixer).to receive(:halt).with(0)
        end

        it '最初のものを停止する' do
          3.times { sound.play }
        end
      end
    end

    context 'MIDI file', midi: true do
      subject { sound.play }

      it 'SDL::Mixer.play_musicを呼び出す' do
        music =
          sound.instance_variable_get('@sound').instance_variable_get('@music')
        expect(SDL::Mixer).to receive(:play_music).with(music, -1)
        subject
      end
    end
  end

  describe '#stop' do
    it '再生していないサウンドを停止でエラーが発生しない' do
      sound = DXRubySDL::Sound.new(fixture_path('sound.wav'))
      expect { sound.stop }.to_not raise_error
    end

    context 'WAVE file', wave: true do
      let(:path) { fixture_path('sound.wav') }
      let(:sound) { DXRubySDL::Sound.new(path) }

      subject { sound.stop }

      before do
        allow(SDL::Mixer).to receive(:halt)
        sound.play
        subject
      end

      describe SDL::Mixer do
        it { expect(SDL::Mixer).to have_received(:halt).with(0).once }
      end
    end

    context 'MIDI file', midi: true do
      let(:path) { fixture_path('bgm.mid') }
      let(:sound) { DXRubySDL::Sound.new(path) }

      subject { sound.stop }

      before do
        allow(SDL::Mixer).to receive(:halt_music)
        sound.play
        subject
      end

      describe SDL::Mixer do
        it { expect(SDL::Mixer).to have_received(:halt_music).with(no_args).once }
      end
    end
  end
end
