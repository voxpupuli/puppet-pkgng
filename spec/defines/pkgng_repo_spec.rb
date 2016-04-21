require 'spec_helper'

describe 'pkgng::repo' do
  on_supported_os.each do |os,facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'pkg.example.com' }

      it { should contain_pkgng__repo('pkg.example.com') }
      it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf') }

      context 'with invalid protocol' do
        let(:params) { {:protocol => 'git://somewheregood' } }
        it {
          raise_error(Puppet::ParseError)
        }
      end

      context 'with invalid mirror_type' do
        let(:params) { {:mirror_type => 'git://somewheregood' } }
        it {
          raise_error(Puppet::ParseError)
        }
      end
    end
  end
end

