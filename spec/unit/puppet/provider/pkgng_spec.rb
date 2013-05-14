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
    provider_class.stubs(:command).with(:pkg).returns('/usr/local/sbin/pkg')
  end

  context "::instances" do
    it "should return nil if execution failed" do
      provider_class.expects(:pkg).raises(Puppet::ExecutionFailure, 'wawawa')
      provider_class.instances.should be_nil
    end
  end

end

