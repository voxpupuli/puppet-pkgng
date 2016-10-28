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

      context 'with priority set to a valid number' do
        let(:params) { {:priority => 12} }
        it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
          :content => /\s+priority:\s+12,$/
        )}
      end

      context 'with priority set to an invalid number' do
        let(:params) { {:priority => 101} }
        it {
          raise_error(Puppet::ParseError)
        }
      end

      context 'with pubkey set' do
        let(:params) { {:pubkey => '/path/to/pubkey'} }
        it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
          :content => /^\s+signature_type:\s+"pubkey",$/
        )}

        it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
          :content => /^\s+pubkey:\s+"\/path\/to\/pubkey",$/
        )}
      end

      context 'with fingerprints set' do
        let(:params) { {:fingerprints => '/path/to/fingerprints'} }
        it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
          :content => /^\s+signature_type:\s+"fingerprints",$/
        )}

        it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
          :content => /^\s+fingerprints:\s+"\/path\/to\/fingerprints",$/
        )}
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
                :protocol => "#{protocol}",
                :mirror_type => mirror_type,
              } }
              it { should contain_pkgng__repo('pkg.example.com') }
              if mirror_type =~ /^srv$/
                it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
                  :content => /\s+url:\s+"pkg\+#{protocol}:\/\/pkg.example.com\/\$\{ABI\}\/latest"/
                )}
              else
                it { should contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
                  :content => /\s+url:\s+"#{protocol}:\/\/pkg.example.com\/\$\{ABI\}\/latest"/
                )}
              end
            end
          }
        end
      }
    end
  end
end

