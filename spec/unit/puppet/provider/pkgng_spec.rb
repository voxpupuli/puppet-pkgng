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
    provider.stub(:command).with(:pkg) {'/usr/local/sbin/pkg'}
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
        %w{GeoIP ca_root_nss curl nginx nmap openldap-sasl-client
        pkg postfix ruby sudo tmux vim-lite zfs-stats zsh}.sort
    end
  end

  context "#install" do
    it "should fail if pkg.conf does not exist" do
      File.stub(:exist?).with('/usr/local/etc/pkg.conf') { false }
      expect{ provider.install }.to raise_error(Puppet::Error, /pkg.conf does not exist/)
    end
  end

  context "#query" do
    # This is being commented out as I am not sure how to test the code when
    # using prefetching.  I somehow need to pass a fake resources object into
    # #prefetch so that it can build the @property_hash, but I am not sure how.
    #
    #it "should return the installed version if present" do
    #  fixture = File.read('spec/fixtures/pkg.query')
    #  provider_class.stub(:get_resource_info) { fixture }
    #  resource[:name] = 'zsh'
    #  expect(provider.query).to eq({:version=>'5.0.2'})
    #end

    it "should return nil if not present" do
      fixture = File.read('spec/fixtures/pkg.query_absent')
      provider_class.stub(:get_resource_info).with('bash') { fixture }
      expect(provider.query).to equal(nil)
    end
  end

end

