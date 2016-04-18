require 'spec_helper'

describe 'pkgng' do
  on_supported_os.each do |os,facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { should contain_class('pkgng') }
      it { should contain_class('pkgng::params') }
      it { should contain_file('/etc/pkg').with(:ensure => 'directory') }
      it { should contain_file('/usr/local/etc/pkg').with(:ensure => 'directory') }
      it { should contain_file('/usr/local/etc/pkg/repos').with(:ensure => 'directory') }
      it { should contain_file('/usr/local/etc/pkg.conf') }
    end
  end
end

