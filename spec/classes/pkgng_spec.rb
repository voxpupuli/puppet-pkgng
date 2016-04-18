require 'spec_helper'

describe 'pkgng' do
  on_supported_os.each do |os,facts|
    let(:facts) { facts }

    it { should contain_class('pkgng') }

  end
end

