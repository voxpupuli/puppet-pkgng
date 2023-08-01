# This configures the PkgNG Package manager on FreeBSD systems, and adds
# support for managing packages with Puppet.  This will eventually be in
# mainline FreeBSD, but for now, we are leaving the installation up to the
# administrator, since there is no going back.
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
# @param options Extra options to write to pkg.conf(5)
# @param purge_repos_d Whether unmanaged repositories should be removed
# @param repos Repositories to manage using create_resources()
#
class pkgng (
  Stdlib::Absolutepath $pkg_dbdir     = '/var/db/pkg',
  Stdlib::Absolutepath $pkg_cachedir  = '/var/cache/pkg',
  Stdlib::Absolutepath $portsdir      = '/usr/ports',
  Array[String]        $options       = [],
  Boolean              $purge_repos_d = true,
  Hash                 $repos         = {},
) {
  unless $facts['kernel'] == 'FreeBSD' {
    fail("pkg() is not supported on ${facts['kernel']}")
  }

  file { '/usr/local/etc/pkg.conf':
    content => epp('pkgng/pkg.conf.epp'),
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
