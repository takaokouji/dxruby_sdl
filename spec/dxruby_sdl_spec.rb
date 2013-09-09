# -*- coding: utf-8 -*-
require 'spec_helper'

describe DXRubySDL do
  describe '::VERSION' do
    subject { described_class::VERSION }

    it { should be_instance_of(String) }
    it { should match(/\A[0-9]\.[0-9]+\.[0-9]+\z/) }
  end

  shared_examples 'constant' do |name, value|
    it "::#{name}の値は#{value}である" do
      expect(DXRubySDL.const_get(name.to_sym)).to eq(value)
    end
  end

  %w[
    DIK_0
    DIK_1
    DIK_2
    DIK_3
    DIK_4
    DIK_5
    DIK_6
    DIK_7
    DIK_8
    DIK_9
    DIK_A
    DIK_ABNT_C1
    DIK_ABNT_C2
    DIK_ADD
    DIK_APOSTROPHE
    DIK_APPS
    DIK_AT
    DIK_AX
    DIK_B
    DIK_BACK
    DIK_BACKSLASH
    DIK_C
    DIK_CALCULATOR
    DIK_CAPITAL
    DIK_COLON
    DIK_COMMA
    DIK_CONVERT
    DIK_D
    DIK_DECIMAL
    DIK_DELETE
    DIK_DIVIDE
    DIK_DOWN
    DIK_E
    DIK_END
    DIK_EQUALS
    DIK_ESCAPE
    DIK_F
    DIK_F1
    DIK_F2
    DIK_F3
    DIK_F4
    DIK_F5
    DIK_F6
    DIK_F7
    DIK_F8
    DIK_F9
    DIK_F10
    DIK_F11
    DIK_F12
    DIK_F13
    DIK_F14
    DIK_F15
    DIK_G
    DIK_GRAVE
    DIK_H
    DIK_HOME
    DIK_I
    DIK_INSERT
    DIK_J
    DIK_K
    DIK_KANA
    DIK_KANJI
    DIK_L
    DIK_LBRACKET
    DIK_LCONTROL
    DIK_LEFT
    DIK_LMENU
    DIK_LSHIFT
    DIK_LWIN
    DIK_M
    DIK_MAIL
    DIK_MEDIASELECT
    DIK_MEDIASTOP
    DIK_MINUS
    DIK_MULTIPLY
    DIK_MUTE
    DIK_MYCOMPUTER
    DIK_N
    DIK_NEXT
    DIK_NEXTTRACK
    DIK_NOCONVERT
    DIK_NUMLOCK
    DIK_NUMPAD0
    DIK_NUMPAD1
    DIK_NUMPAD2
    DIK_NUMPAD3
    DIK_NUMPAD4
    DIK_NUMPAD5
    DIK_NUMPAD6
    DIK_NUMPAD7
    DIK_NUMPAD8
    DIK_NUMPAD9
    DIK_NUMPADCOMMA
    DIK_NUMPADENTER
    DIK_NUMPADEQUALS
    DIK_O
    DIK_OEM_102
    DIK_P
    DIK_PAUSE
    DIK_PERIOD
    DIK_PLAYPAUSE
    DIK_POWER
    DIK_PREVTRACK
    DIK_PRIOR
    DIK_Q
    DIK_R
    DIK_RBRACKET
    DIK_RCONTROL
    DIK_RETURN
    DIK_RIGHT
    DIK_RMENU
    DIK_RSHIFT
    DIK_RWIN
    DIK_S
    DIK_SCROLL
    DIK_SEMICOLON
    DIK_SLASH
    DIK_SLEEP
    DIK_SPACE
    DIK_STOP
    DIK_SUBTRACT
    DIK_SYSRQ
    DIK_T
    DIK_TAB
    DIK_U
    DIK_UNDERLINE
    DIK_UNLABELED
    DIK_UP
    DIK_V
    DIK_VOLUMEDOWN
    DIK_VOLUMEUP
    DIK_W
    DIK_WAKE
    DIK_WEBBACK
    DIK_WEBFAVORITES
    DIK_WEBFORWARD
    DIK_WEBHOME
    DIK_WEBREFRESH
    DIK_WEBSEARCH
    DIK_WEBSTOP
    DIK_X
    DIK_Y
    DIK_YEN
    DIK_Z
  ].each.with_index do |dik_name, i|
    include_examples 'constant', dik_name.sub(/\ADI/, ''), i
  end

  %w[
    P_LEFT
    P_RIGHT
    P_UP
    P_DOWN
    P_BUTTON0
    P_BUTTON1
    P_BUTTON2
    P_BUTTON3
    P_BUTTON4
    P_BUTTON5
    P_BUTTON6
    P_BUTTON7
    P_BUTTON8
    P_BUTTON9
    P_BUTTON10
    P_BUTTON11
    P_BUTTON12
    P_BUTTON13
    P_BUTTON14
    P_BUTTON15
    P_D_LEFT
    P_D_RIGHT
    P_D_UP
    P_D_DOWN
    P_R_LEFT
    P_R_RIGHT
    P_R_UP
    P_R_DOWN
  ].each.with_index do |name, i|
    include_examples 'constant', name, i
  end

  %w[
    P_L_LEFT
    P_L_RIGHT
    P_L_UP
    P_L_DOWN
  ].each.with_index do |name, i|
    include_examples 'constant', name, i
  end

  %w[
    M_LBUTTON
    M_RBUTTON
    M_MBUTTON
  ].each.with_index do |name, i|
    include_examples 'constant', name, i
  end
end
