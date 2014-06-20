# This configures the PkgNG Package manager on FreeBSD systems, and adds
# support for managing packages with Puppet.  This will eventually be in
# mainline FreeBSD, but for now, we are leaving the installation up to the
# adminstrator, since there is no going back.
# To install PkgNG, one can simply run the following:
# make -C /usr/ports/ports-mgmg/pkg install clean

class pkgng (
  $pkg_dbdir     = $pkgng::params::pkg_dbdir,
  $pkg_cachedir  = $pkgng::params::pkg_cachedir,
  $portsdir      = $pkgng::params::portsdir,
  $purge_repos_d = false,
  $repos         = {},
) inherits pkgng::params {

  # PkgNG versions before 1.1.4 use another method of defining repositories
  if ! $::pkgng_supported or versioncmp($::pkgng_version, '1.1.4') < 0 {
    fail('PKGng is either not supported on your system or it is too old')
  }

  # Validate $purge_repos_d boolean
  validate_bool($purge_repos_d)

  file { '/usr/local/etc/pkg.conf':
    content => "PKG_DBDIR: ${pkg_dbdir}\nPKG_CACHEDIR: ${pkg_cachedir}\nPORTSDIR: ${portsdir}\n",
    notify  => Exec['pkg update'],
  }

  # make sure repo config dir is present
  file { '/usr/local/etc/pkg':
    ensure => directory,
  }

  if $purge_repos_d == true {
    File['/usr/local/etc/pkg/repos'] {
      recurse => true,
      purge   => true,
    }
  }

  file { '/usr/local/etc/pkg/repos':
    ensure => directory,
  }

  file { '/etc/make.conf':
    ensure => present,
  }

  file_line { 'WITH_PKGNG':
    path    => '/etc/make.conf',
    line    => "WITH_PKGNG=yes\n",
    require => File['/etc/make.conf'],
  }

  # Triggered on config changes
  exec { 'pkg update':
    path        => '/usr/local/sbin',
    refreshonly => true,
    command     => 'pkg -q update -f',
  }

  # This exec should really on ever be run once, and only upon converting to
  # pkgng. If you are building up a new system where the only software that
  # has been installed form ports is the pkgng itself, then the pkg database
  # is already up to date, and this is not required. As you will see,
  # refreshonly, but nothing notifies this. I am uncertain at this time how
  # to proceed, other than manually.
  exec { 'convert pkg database to pkgng':
    path        => '/usr/local/sbin',
    refreshonly => true,
    command     => 'pkg2ng',
    require     => File['/etc/make.conf'],
  }

  # expand all pkg repositories from hashtable
  create_resources('pkgng::repo', $repos)
}
