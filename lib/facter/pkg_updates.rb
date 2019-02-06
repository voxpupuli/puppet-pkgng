pkg_package_updates = []
pkg_package_vulnerables = []

Facter.add('pkg_has_updates') do
  confine osfamily: 'FreeBSD'
  setcode do
    if File.executable?('/usr/sbin/pkg')
      pkg_version_result = Facter::Util::Resolution.exec('/usr/sbin/pkg version -RUql"<"')
      unless pkg_version_result.nil?
        pkg_version_result.each_line do |line|
          package = line.split.first
          pkg_package_updates.push(package)
        end
      end
    end

    pkg_package_updates.any?
  end
end

Facter.add('pkg_updates') do
  confine pkg_has_updates: true
  setcode do
    Integer(pkg_package_updates.length)
  end
end

Facter.add('pkg_package_updates') do
  confine pkg_has_updates: true
  setcode do
    if Facter.version < '2.0.0'
      pkg_package_updates.join(',')
    else
      pkg_package_updates
    end
  end
end

Facter.add('pkg_has_vulnerabilities') do
  confine osfamily: 'FreeBSD'
  setcode do
    if File.executable?('/usr/sbin/pkg')
      pkg_package_vulnerables = Facter::Util::Resolution.exec('/usr/sbin/pkg audit -q').split.map(&:chomp)
    end

    pkg_package_vulnerables.any?
  end
end

Facter.add('pkg_vulnerabilities') do
  confine pkg_has_vulnerabilities: true
  setcode do
    Integer(pkg_package_vulnerables.count)
  end
end

Facter.add('pkg_vulnerable_packages') do
  confine pkg_has_vulnerabilities: true
  setcode do
    if Facter.version < '2.0.0'
      pkg_package_vulnerables.join(',')
    else
      pkg_package_vulnerables
    end
  end
end
