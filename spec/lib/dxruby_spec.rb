# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'require \'dxruby\'' do
  before do
    require 'dxruby'
  end

  %w[
    Window
    Image
    Font
  ].each do |klass_name|
    it "トップレベルに#{klass_name}が定義されている" do
      expect {
        # rubocop:disable Eval
        eval("::#{klass_name}")
        # rubocop:enable Eval
      }.not_to raise_error
    end
  end
end
