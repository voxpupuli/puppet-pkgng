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

      {
        'http' => [
          'http',
          'https',
          'ftp',
          'file',
          'ssh',
        ],
        'srv' => [
          'http',
          'https',
        ]
      }.each {|k,v|
        mirror_type = k
        context "mirror_type => #{mirror_type}" do
          v.each {|p|
            protocol = p
            context "protocol => #{protocol}" do
              let(:params) { {
                :protocol => "#{protocol}://somewheregood",
                :mirror_type => mirror_type,
              } }
              it { should contain_pkgng__repo('pkg.example.com') }
            end
          }
        end
      }
    end
  end
end

