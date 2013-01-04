# This configures the PkgNG Package manager on FreeBSD systems, and adds
# support for managing packages with Puppet.  This will eventually be in
# mainline FreeBSD, but for now, we are leaving the installation up to the
# adminstrator, since there is no going back.
# To install PkgNG, one can simply run the following:
# make -C /usr/ports/ports-mgmg/pkg install clean

class pkgng (
  $packagesite  = $pkgng::params::packagesite,
  $srv_mirrors  = $pkgng::params::srv_mirrors,
  $pkg_dbdir    = $pkgng::params::pkg_dbdir,
  $pkg_cachedir = $pkgng::params::pkg_cachedir,
  $portsdir     = $pkgng::params::portsdir,
) inherits pkgng::params {

  # At the time of this writing, only FreeBSD 9 and 10 are supported by pkgng
  if $pkgng_supported {
    file { "/usr/local/etc/pkg.conf":
      content  => "PACKAGESITE: ${packagesite}",
      notify   => Exec['pkg update'],
    }

    concat { "/etc/make.conf.local": }
    concat::fragment { "pkgng in make.conf.local":
      target  => '/etc/make.conf.local',
      content => "WITH_PKGNG=yes\n",
    }

    # This is not strictly needed
    cron { "nighty_pkgng_update":
      command => "/usr/local/sbin/pkg update -q",
      minute  => fqdn_rand(60),
      hour    => fqdn_rand(4),
      require => File["/usr/local/etc/pkg.conf"],
    }

    # Triggered on config changes
    exec { "pkg update":
      path        => '/usr/local/sbin',
      refreshonly => true,
      command     => "pkg -q update -f",
    }

    # This exec should really on ever be run once, and only upon converting to
    # pkgng.  If you are building up a new system where the only software that
    # has been installed form ports is the pkgng itself, then the pkg database
    # is already up to date, and this is not required.  As you will see,
    # refreshonly, but nothing notifies this.  I am uncertain at this time how
    # to proceed, other than manually.
    exec { "convert pkg database to pkgng":
      path        => '/usr/local/sbin',
      refreshonly => true,
      command     => "pkg2ng",
    }
  } else {
    notice("pkgng is not supported on this release")
  }

}
