require 'spec_helper'

describe 'pkgng' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to contain_class('pkgng') }
      it { is_expected.to contain_class('pkgng::params') }
      it { is_expected.to contain_file('/usr/local/etc/pkg').with(ensure: 'directory') }
      it { is_expected.to contain_file('/usr/local/etc/pkg/repos').with(ensure: 'directory') }
      it { is_expected.to contain_file('/usr/local/etc/pkg.conf') }
    end
  end
end
