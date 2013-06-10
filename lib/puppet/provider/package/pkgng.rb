require 'puppet/provider/package'
Puppet::Type.type(:package).provide :pkgng, :parent => Puppet::Provider::Package do
  desc "A PKGng provider for FreeBSD."

  commands :pkg => "/usr/local/sbin/pkg"

  confine :operatingsystem => :freebsd
  defaultfor :operatingsystem => :freebsd if $pkgng_enabled


  def self.get_info
    pkg(['info','-a'])
  end

  def self.instances
    packages = []
    begin
      info = self.get_info

      unless info
        return packages
      end

      info.lines.each do |line|
        pkgs = line.split
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
