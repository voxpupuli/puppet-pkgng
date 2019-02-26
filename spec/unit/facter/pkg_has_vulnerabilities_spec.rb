require 'spec_helper'

describe 'pkg_has_vulnerabilities fact' do
  subject { Facter.fact(:pkg_has_vulnerabilities).value }

  after { Facter.clear }

  before { Facter.fact(:osfamily).expects(:value).returns(osfamily) }

  context 'on non FreeBSD host' do
    let(:osfamily) { 'Debian' }

    it { is_expected.to be_nil }
  end

  context 'on FreeBSD host' do
    let(:osfamily) { 'FreeBSD' }

    before do
      File.stubs(:executable?)
      File.expects(:executable?).with('/usr/sbin/pkg').returns true
      Facter::Util::Resolution.expects(:exec).with('/usr/sbin/pkg audit -q').returns(pkg_audit_output)
    end
    context 'without package vulnerabilities' do
      let(:pkg_audit_output) { '' }

      it { is_expected.to be false }
    end
    context 'with package vulnerabilities' do
      let(:pkg_audit_output) { "apr-1.6.2.1.6.0\napache24-2.4.27\n" }

      it { is_expected.to be true }
    end
  end
end
