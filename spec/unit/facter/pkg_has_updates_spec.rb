require 'spec_helper'

describe 'pkg_has_updates fact' do
  subject { Facter.fact(:pkg_has_updates).value }

  after { Facter.clear }

  before do
    allow(Facter.fact(:osfamily)).to receive(:value) { osfamily }
  end

  context 'on non FreeBSD host' do
    let(:osfamily) { 'Debian' }

    it { is_expected.to be_nil }
  end

  context 'on FreeBSD host' do
    let(:osfamily) { 'FreeBSD' }

    before do
      allow(File).to receive(:executable?) { false }
      allow(File).to receive(:executable?).with('/usr/sbin/pkg') { true }
      allow(Facter::Util::Resolution).to receive(:exec).with('/usr/sbin/pkg version -RUql"<"') { pkg_version_output }
    end

    context 'without package updates' do
      let(:pkg_version_output) { '' }

      it { is_expected.to be false }
    end

    context 'with package updates' do
      let(:pkg_version_output) { "apr-1.6.2.1.6.0\napache24-2.4.27\n" }

      it { is_expected.to be true }
    end
  end
end
