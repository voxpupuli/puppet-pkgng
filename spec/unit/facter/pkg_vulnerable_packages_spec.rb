# frozen_string_literal: true

require 'spec_helper'

describe 'pkg_vulnerable_packages fact' do
  subject { Facter.fact(:pkg_vulnerable_packages).value }

  after { Facter.clear }

  before do
    allow(File).to receive(:executable?).and_return(false)
    allow(File).to receive(:executable?).with('/usr/sbin/pkg').and_return(true)
    allow(Facter.fact(:osfamily)).to receive(:value).and_return('FreeBSD')
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/sbin/pkg audit -q').and_return(pkg_audit_output)
  end

  context 'when there is no update' do
    let(:pkg_audit_output) { '' }

    it { is_expected.to be_nil }
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
