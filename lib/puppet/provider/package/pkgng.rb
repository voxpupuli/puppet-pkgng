require 'puppet/provider/package'
Puppet::Type.type(:package).provide :pkgng, :parent => Puppet::Provider::Package do
  desc "A PKGng provider for FreeBSD."

  commands :pkg => "/usr/local/sbin/pkg"

  confine :operatingsystem => :freebsd
  defaultfor :operatingsystem => :freebsd if $pkgng_enabled

  def self.instances
    packages = []
    inst = []
    begin
      pkg_list = pkg(['info','-a']).lines

      pkg_list.each do |pkgs|
        pkgs = pkgs.split
        pkg_info = pkgs[0].split('-')
        pkg = {
          :ensure   => pkg_info.pop,
          :name     => pkg_info.join('-'),
          :provider => self.name
        }
        packages << new(pkg)
      end

      return packages
    rescue Puppet::ExecutionFailure
      nil
    end
  end

  def install
    should = @resource.should(:ensure)
    cmd = ['install', '-qy', @resource[:name]]
    pkg(*cmd)
  end

  def uninstall
    cmd = ['remove', '-qy', @resource[:name]]
    pkg(*cmd)
  end

  def query
    hash = Hash.new
    #cmd = ["query", "'%v'", @resource[:name]]
    cmd = ["info", "-q", @resource[:name]]
    begin
      hash[:ensure] = pkg(*cmd)
      hash
    rescue
      hash[:ensure] = :purged
      hash
    end
  end

end
