# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL::Input,
         'キーボード・ゲームパッド・マウスの入力を扱うモジュール' do
  def push_key_down_event(sym)
    e = SDL::Event::KeyDown.new
    e.press = true
    e.sym = sym
    e.mod = 0
    e.unicode = 0
    SDL::Event.push(e)
  end

  def push_key_up_event(sym)
    e = SDL::Event::KeyUp.new
    e.press = false
    e.sym = sym
    e.mod = 0
    e.unicode = 0
    SDL::Event.push(e)
  end

  def update_input_keys
    expect {
      DXRubySDL::Window.loop do
        SDL::Event.push(SDL::Event::Quit.new)
      end
    }.to raise_error(SystemExit)
  end

  shared_context '.set_repeat' do
    before do
      SDL::Key.stub(:enable_key_repeat)
      subject
    end

    specify do
      expect(SDL::Key).to have_received(:enable_key_repeat).with(15, 2)
    end
  end

  describe '.set_repeat', 'キーリピートを設定する' do
    subject { described_class.set_repeat(15, 2) }

    include_context '.set_repeat'

    describe 'alias' do
      describe '.setRepeat' do
        it_behaves_like '.set_repeat' do
          subject { described_class.setRepeat(15, 2) }
        end
      end
    end
  end

  shared_context 'push key_down events' do
    let(:_keys) { [] }

    before do
      _keys.each { |key| push_key_down_event(key) }
      update_input_keys
    end
  end

  describe '.x' do
    include_context 'push key_down events'

    subject { described_class.x }

    context '左カーソルが押されている場合' do
      let(:_keys) { [SDL::Key::LEFT] }

      it { should eq(-1) }
    end

    context '右カーソルが押されている場合' do
      let(:_keys) { [SDL::Key::RIGHT] }

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
    include_context 'push key_down events'

    subject { described_class.y }

    context '上カーソルが押されている場合' do
      let(:_keys) { [SDL::Key::UP] }

      it { should eq(-1) }
    end

    context '下カーソルが押されている場合' do
      let(:_keys) { [SDL::Key::DOWN] }

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
    include_context 'push key_down events'

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
       ['ボタン0', :P_BUTTON0, :Z],
       ['ボタン1', :P_BUTTON1, :X],
       ['ボタン2', :P_BUTTON2, :C],
       ['左ボタン', :P_LEFT, :LEFT],
       ['右ボタン', :P_RIGHT, :RIGHT],
       ['上ボタン', :P_UP, :UP],
       ['下ボタン', :P_DOWN, :DOWN],
       # rubocop:enable SymbolName
      ].each do |_button_name, _button, _key|
        describe "ゲームパッドの#{_button_name}" do
          let(:button_code) { DXRubySDL.const_get(_button) }

          context "ゲームパッドの#{_button_name}が押されている場合" do
            let(:joystick) {
              j = double('Joystick')
              allow(j).to receive(:button) { |button_index|
                            button_index == DXRubySDL.const_get(_button)
                          }
              j
            }

            it { should be true }
          end

          context "#{_key}キーが押されている場合" do
            let(:_keys) { [SDL::Key.const_get(_key)] }

            it { should be true }
          end

          context 'ボタンやキーが押されていない場合' do
            it { should be false }
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
       ['ボタン0', :P_BUTTON0, :Z],
       ['ボタン1', :P_BUTTON1, :X],
       ['ボタン2', :P_BUTTON2, :C],
       ['左ボタン', :P_LEFT, :LEFT],
       ['右ボタン', :P_RIGHT, :RIGHT],
       ['上ボタン', :P_UP, :UP],
       ['下ボタン', :P_DOWN, :DOWN],
       # rubocop:enable SymbolName
      ].each do |_button_name, _button, _key|
        describe "ゲームパッドの#{_button_name}" do
          let(:button_code) { DXRubySDL.const_get(_button) }

          context "#{_key}キーが押されている場合" do
            let(:_keys) { [SDL::Key.const_get(_key)] }

            it { should be true }
          end

          context 'ボタンやキーが押されていない場合' do
            it { should be false }
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

  shared_context '.pad_push?' do
    include_context 'push key_down events'

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
       ['ボタン0', :P_BUTTON0, :Z],
       ['ボタン1', :P_BUTTON1, :X],
       ['ボタン2', :P_BUTTON2, :C],
       ['左ボタン', :P_LEFT, :LEFT],
       ['右ボタン', :P_RIGHT, :RIGHT],
       ['上ボタン', :P_UP, :UP],
       ['下ボタン', :P_DOWN, :DOWN],
       # rubocop:enable SymbolName
      ].each do |_button_name, _button, _key|
        describe "ゲームパッドの#{_button_name}" do
          let(:button_code) { DXRubySDL.const_get(_button) }

          context "ゲームパッドの#{_button_name}が押されている場合" do
            let(:joystick) {
              j = double('Joystick')
              allow(j).to receive(:button) { |button_index|
                            button_index == DXRubySDL.const_get(_button)
                          }
              j
            }

            it { should be true }
          end

          context "#{_key}キーが押されている場合" do
            let(:_keys) { [SDL::Key.const_get(_key)] }

            it { should be true }
          end

          context 'ボタンやキーが押されていない場合' do
            it { should be false }
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
       ['ボタン0', :P_BUTTON0, :Z],
       ['ボタン1', :P_BUTTON1, :X],
       ['ボタン2', :P_BUTTON2, :C],
       ['左ボタン', :P_LEFT, :LEFT],
       ['右ボタン', :P_RIGHT, :RIGHT],
       ['上ボタン', :P_UP, :UP],
       ['下ボタン', :P_DOWN, :DOWN],
       # rubocop:enable SymbolName
      ].each do |_button_name, _button, _key|
        describe "ゲームパッドの#{_button_name}" do
          let(:button_code) { DXRubySDL.const_get(_button) }

          context "#{_key}キーが押されている場合" do
            let(:_keys) { [SDL::Key.const_get(_key)] }

            it { should be true }
          end

          context 'ボタンやキーが押されていない場合' do
            it { should be false }
          end
        end
      end
    end
  end

  describe '.pad_push?', 'パッドのボタン状態を返す' do
    subject { described_class.pad_push?(button_code) }

    include_context '.pad_push?'

    describe 'alias' do
      describe '.padPush?' do
        it_behaves_like '.pad_push?' do
          subject { described_class.padPush?(button_code) }
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

  shared_context '.key_down?' do
    include_context 'push key_down events'

    context 'ESCAPEキーが押されている場合' do
      let(:_keys) { [SDL::Key::ESCAPE] }
      let(:key_code) { DXRubySDL::K_ESCAPE }

      it { should be true }
    end
  end

  describe '.key_down?' do
    subject { described_class.key_down?(key_code) }

    include_context '.key_down?'

    describe 'alias' do
      describe '.keyDown?' do
        it_behaves_like '.key_down?' do
          subject { described_class.keyDown?(key_code) }
        end
      end
    end
  end

  shared_context '.key_push?' do
    include_context 'push key_down events'

    subject { described_class.send(method, key_code) }

    context 'ESCAPEキーが押されている場合' do
      let(:_keys) { [SDL::Key::ESCAPE] }
      let(:key_code) { DXRubySDL::K_ESCAPE }

      it { should be true }

      context 'キーが押しっぱなしの場合' do
        before do
          down_keys = described_class.instance_variable_get('@down_keys')
          down_keys.add(key_code)
        end

        it { should be false }
      end

      context 'キーが押しっぱなしだが、' \
              'Input.key_push?をメインループで毎回処理しない場合' do
        specify '最初の1回以外は全てfalseを返す' do
          begin
            first = true
            i = 0
            DXRubySDL::Window.loop do
              if first
                expect(described_class.send(method, key_code)).to be true
                first = false
              else
                if i.even?
                  expect(described_class.send(method, key_code)).to be false
                end
              end
              i += 1
              if i > 10
                SDL::Event.push(SDL::Event::Quit.new)
              end
            end
          rescue SystemExit
          end
        end
      end
    end
  end

  describe '.key_push?' do
    let(:method)  { :key_push? }

    include_context '.key_push?'

    describe 'alias' do
      describe '.keyPush?' do
        let(:method)  { 'keyPush?' }

        it_behaves_like '.key_push?'
      end
    end
  end

  shared_context '.mouse_down?' do
    context 'マウスの左ボタンを押している場合' do
      before do
        allow(SDL::Mouse)
          .to receive(:state).and_return([0, 0, true, false, false])
      end

      describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_LBUTTON }

        it { should be true }
      end

      describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_MBUTTON }

        it { should be false }
      end

      describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_RBUTTON }

        it { should be false }
      end
    end

    context 'マウスの中ボタンを押している場合' do
      before do
        allow(SDL::Mouse)
          .to receive(:state).and_return([0, 0, false, true, false])
      end

      describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_LBUTTON }

        it { should be false }
      end

      describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_MBUTTON }

        it { should be true }
      end

      describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_RBUTTON }

        it { should be false }
      end
    end

    context 'マウスの右ボタンを押している場合' do
      before do
        allow(SDL::Mouse)
          .to receive(:state).and_return([0, 0, false, false, true])
      end

      describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_LBUTTON }

        it { should be false }
      end

      describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_MBUTTON }

        it { should be false }
      end

      describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
        let(:button) { DXRubySDL::M_RBUTTON }

        it { should be true }
      end
    end
  end

  describe '.mouse_down?' do
    subject { described_class.mouse_down?(button) }

    include_context '.mouse_down?'

    describe 'alias' do
      describe '.mouseDown?' do
        it_behaves_like '.mouse_down?' do
          subject { described_class.mouseDown?(button) }
        end
      end
    end
  end

  shared_context '.mouse_push?' do
    context '直前にマウスのボタンを押していない場合' do
      before do
        described_class.instance_variable_set('@last_mouse_state',
                                              [0, 0, false, false, false])
      end

      context 'マウスの左ボタンを押している場合' do
        before do
          allow(SDL::Mouse)
            .to receive(:state).and_return([0, 0, true, false, false])
        end

        describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_LBUTTON }

          it { should be true }
        end

        describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_MBUTTON }

          it { should be false }
        end

        describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_RBUTTON }

          it { should be false }
        end
      end

      context 'マウスの中ボタンを押している場合' do
        before do
          allow(SDL::Mouse)
            .to receive(:state).and_return([0, 0, false, true, false])
        end

        describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_LBUTTON }

          it { should be false }
        end

        describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_MBUTTON }

          it { should be true }
        end

        describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_RBUTTON }

          it { should be false }
        end
      end

      context 'マウスの右ボタンを押している場合' do
        before do
          allow(SDL::Mouse)
            .to receive(:state).and_return([0, 0, false, false, true])
        end

        describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_LBUTTON }

          it { should be false }
        end

        describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_MBUTTON }

          it { should be false }
        end

        describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_RBUTTON }

          it { should be true }
        end
      end
    end

    context '直前にマウスのボタンを全て押していた場合' do
      before do
        described_class.instance_variable_set('@last_mouse_state',
                                              [0, 0, true, true, true])
      end

      context 'マウスの左ボタンを押している場合' do
        before do
          allow(SDL::Mouse)
            .to receive(:state).and_return([0, 0, true, false, false])
        end

        describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_LBUTTON }

          it { should be false }
        end

        describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_MBUTTON }

          it { should be false }
        end

        describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_RBUTTON }

          it { should be false }
        end
      end

      context 'マウスの中ボタンを押している場合' do
        before do
          allow(SDL::Mouse)
            .to receive(:state).and_return([0, 0, false, true, false])
        end

        describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_LBUTTON }

          it { should be false }
        end

        describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_MBUTTON }

          it { should be false }
        end

        describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_RBUTTON }

          it { should be false }
        end
      end

      context 'マウスの右ボタンを押している場合' do
        before do
          allow(SDL::Mouse)
            .to receive(:state).and_return([0, 0, false, false, true])
        end

        describe 'マウスの左ボタン(M_LBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_LBUTTON }

          it { should be false }
        end

        describe 'マウスの中ボタン(M_MBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_MBUTTON }

          it { should be false }
        end

        describe 'マウスの右ボタン(M_RBUTTON)を指定する' do
          let(:button) { DXRubySDL::M_RBUTTON }

          it { should be false }
        end
      end
    end
  end

  describe '.mouse_push?' do
    subject { described_class.mouse_push?(button) }

    include_context '.mouse_push?'

    describe 'alias' do
      describe '.mousePush?' do
        it_behaves_like '.mouse_push?' do
          subject { described_class.mousePush?(button) }
        end
      end
    end
  end

  describe '.keys' do
    subject {
      update_input_keys
      described_class.keys
    }

    context 'スペースキー、上カーソルキー、Aキーを押している場合' do
      before do
        push_key_down_event(SDL::Key::SPACE)
        push_key_down_event(SDL::Key::UP)
        push_key_down_event(SDL::Key::DOWN)
        push_key_up_event(SDL::Key::DOWN)
        push_key_down_event(SDL::Key::A)
      end

      it {
        should include(DXRubySDL::K_SPACE, DXRubySDL::K_UP, DXRubySDL::K_A)
      }
    end

    context '下カーソルキーを押したあとに離した場合' do
      before do
        push_key_down_event(SDL::Key::DOWN)
        push_key_up_event(SDL::Key::DOWN)
      end

      it { should be_empty }
    end
  end
end
