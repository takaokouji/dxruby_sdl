require 'spec_helper'

describe DXRubySDL do
  describe '::VERSION' do
    subject { described_class::VERSION }
    
    it { should be_instance_of(String) }
    it { should match(/\A[0-9]\.[0-9]+\.[0-9]+\z/) }
  end

  describe 'require \'dxruby\'' do
    subject { require 'dxruby' }

    it { should be_true }
  end
end
