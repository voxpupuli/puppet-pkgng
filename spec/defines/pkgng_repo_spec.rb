require 'spec_helper'

describe 'pkgng::repo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'pkg.example.com' }

      it { is_expected.to contain_pkgng__repo('pkg.example.com') }
      it { is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf') }

      context 'with invalid protocol' do
        let(:params) { { protocol: 'git://somewheregood' } }

        it do
          raise_error(Puppet::ParseError)
        end
      end

      context 'with invalid mirror_type' do
        let(:params) { { mirror_type: 'git://somewheregood' } }

        it do
          raise_error(Puppet::ParseError)
        end
      end

      context 'with priority set to a valid number' do
        let(:params) { { priority: 12 } }

        it do
          is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
            content: %r{\s+priority:\s+12,$}
          )
        end
      end

      context 'with priority set to an invalid number' do
        let(:params) { { priority: 101 } }

        it do
          raise_error(Puppet::ParseError)
        end
      end

      context 'with pubkey set' do
        let(:params) { { pubkey: '/path/to/pubkey' } }

        it do
          is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
            content: %r{^\s+signature_type:\s+"pubkey",$}
          )
        end

        it do
          is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
            content: %r{^\s+pubkey:\s+"\/path\/to\/pubkey",$}
          )
        end
      end

      context 'with fingerprints set' do
        let(:params) { { fingerprints: '/path/to/fingerprints' } }

        it do
          is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
            content: %r{^\s+signature_type:\s+"fingerprints",$}
          )
        end

        it do
          is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
            content: %r{^\s+fingerprints:\s+"\/path\/to\/fingerprints",$}
          )
        end
      end

      {
        'http' => %w[
          http
          https
          ftp
          file
          ssh
        ],
        'srv' => %w[
          http
          https
        ]
      }.each do |k, v|
        mirror_type = k
        context "mirror_type => #{mirror_type}" do
          v.each do |p|
            protocol = p
            context "protocol => #{protocol}" do
              let(:params) do
                {
                  protocol: protocol.to_s,
                  mirror_type: mirror_type
                }
              end

              it { is_expected.to contain_pkgng__repo('pkg.example.com') }
              if mirror_type =~ %r{^srv$}
                it do
                  is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
                    content: %r{\s+url:\s+"pkg\+#{protocol}:\/\/pkg.example.com\/\$\{ABI\}\/latest"}
                  )
                end
              else
                it do
                  is_expected.to contain_file('/usr/local/etc/pkg/repos/pkg.example.com.conf').with(
                    content: %r{\s+url:\s+"#{protocol}:\/\/pkg.example.com\/\$\{ABI\}\/latest"}
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
