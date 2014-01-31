require 'puppet/provider/package'

Puppet::Type.type(:package).provide :pkgng, :parent => Puppet::Provider::Package do
  desc "A PkgNG provider for FreeBSD."

  commands :pkg => "/usr/local/sbin/pkg"

  confine :operatingsystem => :freebsd
  defaultfor :operatingsystem => :freebsd # if $pkgng_enabled

  has_feature :versionable
  has_feature :upgradeable

  def self.get_info
    @pkg_info = @pkg_info || pkg(['info','-ao'])
    @pkg_info
  end

  def self.get_version_list
    @version_list = @version_list || pkg(['version', '-voRL='])
    @version_list
  end

  def self.get_latest_version(origin)
    if latest_version = self.get_version_list.lines.find { |l| l =~ /^#{origin}/ }
      latest_version = latest_version.split(' ').last.split(')').first
      return latest_version
    end
    nil
  end

  def self.instances
    packages = []
    begin
      info = self.get_info

      unless info
        return packages
      end

      info.lines.each do |line|
        unless line =~ /\w+-\d.*\s*\w\/\w.*/
          debug "skipping line: #{line}"
          next
        end

        package, origin = line.split
        pkg_info        = package.split('-')
        version         = pkg_info.pop
        name            = pkg_info.join('-')
        latest_version  = get_latest_version(origin) || version

        pkg = {
          :ensure   => version,
          :name     => name,
          :provider => self.name,
          :origin   => origin,
          :version  => version,
          :latest   => latest_version
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
    debug @property_hash[:version].inspect
    @property_hash[:version]
  end

  def version=
    pkg(['install', '-qy', "#{resource[:name]}-#{resource[:version]}"])
  end

  def origin
    debug @property_hash[:origin].inspect
    @property_hash[:origin]
  end

  # Upgrade to the latest version
  def update
    debug 'pkgng: update called'
    install
  end

  # Returnthe latest version of the package
  def latest
    debug "returning the latest #{@property_hash[:name].inspect} version #{@property_hash[:latest].inspect}"
    @property_hash[:latest]
  end

end
