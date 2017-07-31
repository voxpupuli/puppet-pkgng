require 'spec_helper'

describe 'pkg_package_vulnerables fact' do
  subject { Facter.fact(:pkg_package_vulnerables).value }
  after { Facter.clear }

  before do
    File.stubs(:executable?)
    Facter.fact(:osfamily).expects(:value).returns 'FreeBSD'
    File.expects(:executable?).with('/usr/sbin/pkg').returns true
    Facter::Util::Resolution.expects(:exec).with('/usr/sbin/pkg audit -q').returns(pkg_audit_output)
  end

  context 'when there is no update' do
    let(:pkg_audit_output) { '' }
    it { is_expected.to be nil }
  end

  context 'when there are updates' do
    let(:pkg_audit_output) { "apr-1.6.2.1.6.0\napache24-2.4.27\n" }
    if Facter.version < '2.0.0'
      it { is_expected.to eq('apr-1.6.2.1.6.0,apache24-2.4.27') }
    else
      it { is_expected.to eq(['apr-1.6.2.1.6.0', 'apache24-2.4.27']) }
    end
  end
end
