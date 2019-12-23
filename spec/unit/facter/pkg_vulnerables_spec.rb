require 'spec_helper'

describe 'pkg_vulnerabilities fact' do
  subject { Facter.fact(:pkg_vulnerabilities).value }

  after { Facter.clear }

  before do
    allow(File).to receive(:executable?) { false }
    allow(File).to receive(:executable?).with('/usr/sbin/pkg') { true }
    allow(Facter.fact(:osfamily)).to receive(:value) { 'FreeBSD' }
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/sbin/pkg audit -q') { pkg_audit_output }
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
