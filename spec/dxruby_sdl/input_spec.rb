# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Input,
         'キーボード・ゲームパッド・マウスの入力を扱うモジュール' do
  after do
    DXRubySDL::Input.instance_variable_set('@joysticks', [])
  end

  shared_context 'push_key' do
    let(:_keys) { [] }

    before do
      allow(SDL::Key).to receive(:scan)
      allow(SDL::Key).to receive(:press?) { |key|
                           [_keys].flatten.include?(key) ? true : false
                         }
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

  shared_context '.pad_down?' do
    include_context 'push_key'

    context 'Joystickが接続されている場合' do
      let(:joystick) {
        j = double('Joystick')
        allow(j).to receive(:button).with(anything).and_return(false)
        j
      }

      before do
        allow(SDL::Joystick).to receive(:num).and_return(1)
        allow(SDL::Joystick).to receive(:open).with(0).and_return(joystick)
      end

      [
       # rubocop:disable SymbolName
       [:P_BUTTON0, :Z],
       [:P_BUTTON1, :X],
       [:P_BUTTON2, :C],
       # rubocop:enable SymbolName
      ].each.with_index do |(_button, _key), i|
        describe "#{i}番目(#{_button})のボタン" do
          let(:button_code) { DXRubySDL.const_get(_button) }

          context "#{i}番目のボタンが押されている場合" do
            let(:joystick) {
              j = double('Joystick')
              allow(j).to receive(:button) { |button_index|
                            button_index == DXRubySDL.const_get(_button)
                          }
              j
            }

            it { should be_true }
          end

          context "#{_key}キーが押されている場合" do
            let(:_keys) { SDL::Key.const_get(_key) }

            it { should be_true }
          end

          context 'ボタンやキーが押されていない場合' do
            it { should be_false }
          end
        end
      end
    end

    context 'Joystickが接続されていない場合' do
      before do
        allow(SDL::Joystick).to receive(:num).and_return(0)
      end

      [
       # rubocop:disable SymbolName
       [:P_BUTTON0, :Z],
       [:P_BUTTON1, :X],
       [:P_BUTTON2, :C],
       # rubocop:enable SymbolName
      ].each.with_index do |(_button, _key), i|
        describe "#{i}番目(#{_button})のボタン" do
          let(:button_code) { DXRubySDL.const_get(_button) }

          context "#{_key}キーが押されている場合" do
            let(:_keys) { SDL::Key.const_get(_key) }

            it { should be_true }
          end

          context 'ボタンやキーが押されていない場合' do
            it { should be_false }
          end
        end
      end
    end
  end

  describe '.pad_down?', 'パッドのボタン状態を返す' do
    subject { described_class.pad_down?(button_code) }

    include_context '.pad_down?'

    describe 'alias' do
      describe '.padDown?' do
        it_behaves_like '.pad_down?' do
          subject { described_class.padDown?(button_code) }
        end
      end
    end
  end

  shared_context '.mouse_pos_x' do
    it { should be_kind_of(Integer) }
  end

  describe '.mouse_pos_x' do
    subject { described_class.mouse_pos_x }

    include_context '.mouse_pos_x'

    describe 'alias' do
      describe '.mousePosX' do
        it_behaves_like '.mouse_pos_x' do
          subject { described_class.mousePosX }
        end
      end
    end
  end

  shared_context '.mouse_pos_y' do
    it { should be_kind_of(Integer) }
  end

  describe '.mouse_pos_y' do
    subject { described_class.mouse_pos_y }

    include_context '.mouse_pos_y'

    describe 'alias' do
      describe '.mousePosY' do
        it_behaves_like '.mouse_pos_y' do
          subject { described_class.mousePosY }
        end
      end
    end
  end

  shared_context '.key_push?' do
    include_context 'push_key'

    context 'ESCAPEキーが押されている場合' do
      let(:_keys) { SDL::Key::ESCAPE }
      let(:key_code) { DXRubySDL::K_ESCAPE }

      it { should be_true }
    end
  end

  describe '.key_push?' do
    subject { described_class.key_push?(key_code) }

    include_context '.key_push?'

    describe 'alias' do
      describe '.keyPush?' do
        it_behaves_like '.key_push?' do
          subject { described_class.keyPush?(key_code) }
        end
      end
    end
  end
end
