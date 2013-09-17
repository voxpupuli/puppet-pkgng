require 'puppet/provider/package'

Puppet::Type.type(:package).provide :pkgng, :parent => Puppet::Provider::Package do
  desc "A PkgNG provider for FreeBSD."

  commands :pkg => "/usr/local/sbin/pkg"

  confine :operatingsystem => :freebsd
  defaultfor :operatingsystem => :freebsd if $pkgng_enabled

  has_feature :versionable

  def self.get_info
    pkg(['info','-ao'])
  end

  def self.instances
    packages = []
    begin
      info = self.get_info

      unless info
        return packages
      end

      info.lines.each do |line|
        package, origin = line.split
        pkg_info = package.split('-')
        version = pkg_info.pop
        name = pkg_info.join('-')
        pkg = {
          :ensure   => :present,
          :name     => name,
          :provider => self.name,
          :version  => version,
          :origin   => origin
        }
        packages << new(pkg)
      end

      return packages
    rescue Puppet::ExecutionFailure
      nil
    end
  end

  def self.prefetch(resources)
    packages = instances
    resources.keys.each do |name|
      if provider = packages.find{|p| p.name == name or p.origin == name }
        resources[name].provider = provider
      end
    end
  end

  def install
    if File.exists?('/usr/local/etc/pkg.conf')
      pkg(['install', '-qy', resource[:name]])
    else
      raise Puppet::Error.new("/usr/local/etc/pkg.conf does not exist")
    end
  end

  def uninstall
    pkg(['remove', '-qy', resource[:name]])
  end

  def query
    debug @property_hash
    if @property_hash[:ensure] == nil
      return nil
    else
      version = @property_hash[:version]
      return { :version => version }
    end
  end

  def version
    debug @property_hash[:version]
    @property_hash[:version]
  end

  def version=
    pkg(['install', '-qy', "#{resource[:name]}-#{resource[:version]}"])
  end

  def origin
    debug @property_hash[:origin]
    @property_hash[:origin]
  end

end
