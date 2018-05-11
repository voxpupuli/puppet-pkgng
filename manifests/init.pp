# This configures the PkgNG Package manager on FreeBSD systems, and adds
# support for managing packages with Puppet.  This will eventually be in
# mainline FreeBSD, but for now, we are leaving the installation up to the
# adminstrator, since there is no going back.
#
# If you have purge_repos_d as true - then you'll have no repositories
# defined unless you define one. You want to do this as you'll want this
# module to control repos anyway.
#
# To install PkgNG, one can simply run the following:
# make -C /usr/ports/ports-mgmg/pkg install clean
#
# @example
#   include pkgng
#
# @param pkg_dbdir Full path to database directory for pkg(8)
# @param pkg_cachedir Full path to cache directory for pkg(8)
# @param portsdir Full path to ports directory
# @param options Array of options to write to pkg.conf(5)
# @param purge_repos_d Boolean when true removes unmanaged repos
# @param repos Hash of resources to pass to create_resources()
#
class pkgng (
  Stdlib::Absolutepath $pkg_dbdir     = $pkgng::params::pkg_dbdir,
  Stdlib::Absolutepath $pkg_cachedir  = $pkgng::params::pkg_cachedir,
  Stdlib::Absolutepath $portsdir      = $pkgng::params::portsdir,
  Array[String]        $options       = [],
  Boolean              $purge_repos_d = true,
  Hash                 $repos         = {},
) inherits pkgng::params {

  unless $::kernel == 'FreeBSD' {
    fail("pkg() is not supported on ${::kernel}")
  }

  file { '/usr/local/etc/pkg.conf':
    content => template('pkgng/pkg.conf'),
    notify  => Exec['pkg update'],
  }

  # make sure repo config dir is present
  file { '/usr/local/etc/pkg':
    ensure => directory,
  }

  file { '/usr/local/etc/pkg/repos':
    ensure  => directory,
    recurse => true,
    purge   => $purge_repos_d,
  }

  # Triggered on config changes
  exec { 'pkg update':
    path        => '/usr/local/sbin',
    refreshonly => true,
    command     => 'pkg update -q -f',
  }

  Exec['pkg update']
  -> Package <| provider == 'pkgng' or provider == undef |>

  # expand all pkg repositories from hashtable
  create_resources('pkgng::repo', $repos)
}
