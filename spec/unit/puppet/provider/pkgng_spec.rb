#! /usr/bin/env ruby
require 'spec_helper'
require 'puppet/provider/package/pkgng'

provider_class = Puppet::Type.type(:package).provider(:pkgng)

describe provider_class do
  let(:name) { 'bash' }
  let(:pkgng) { 'pkgng' }

  let(:resource) do
    Puppet::Type.type(:package).new(:name => name, :provider => pkgng)
  end

  let (:provider) { resource.provider }

  before do
    provider_class.stub(:command).with(:pkg) {'/usr/local/sbin/pkg'}
  end


  context "::instances" do
    it "should return the empty set if no packages are listed" do
      provider_class.stub(:get_info) { '' }
      provider_class.instances.should be_empty
    end

    it "should return all packages when invoked" do
      fixture = File.read('spec/fixtures/pkg.info')
      provider_class.stub(:get_info) { fixture }
      provider_class.instances.map(&:name).sort.should ==
        %w{GeoIP ca_root_nss curl nginx nmap openldap-sasl-client pkg postfix ruby sudo tmux vim-lite zfs-stats zsh}.sort
    end
  end

  context "#query" do
    it "should return the installed version if present" do
    end

    it "should return nothing if not present" do
      #provider.resource[:name] = 'bash'
      #provider.expects(:pkg).with('zsh').returns('')
    end
  end

end

