require 'spec_helper'

describe 'pkg_vulnerabilities fact' do
  subject { Facter.fact(:pkg_vulnerabilities).value }
  after { Facter.clear }

  before do
    File.stubs(:executable?)
    Facter.fact(:osfamily).expects(:value).returns 'FreeBSD'
    File.expects(:executable?).with('/usr/sbin/pkg').returns true
    Facter::Util::Resolution.expects(:exec).with('/usr/sbin/pkg audit -q').returns(pkg_audit_output)
  end

  context 'when there is no vulnerable packages' do
    let(:pkg_audit_output) { '' }
    it { is_expected.to be nil }
  end

  context 'when there are vulnerable packages' do
    let(:pkg_audit_output) { "apr-1.6.2.1.6.0\napache24-2.4.27\n" }
    it { is_expected.to eq(2) }
  end
end
