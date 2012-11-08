class pkgng (
  $packagesite = inline_template("http://pkgbeta.freebsd.org/freebsd-<%= kernelversion.split('.').first %>-${architecture}/latest/")
) {

  # At the time of this writing, only FreeBSD 9 and 10 are supported by pkgng
  if $pkgng_supported {
    file { "/usr/local/etc/pkg.conf":
      content  => "PACKAGESITE: ${packagesite}",
      notify   => Exec['pkg update'],
    }

    concat::fragment { "pkgng in make.conf.local":
      target  => '/etc/make.conf.local',
      content => "WITH_PKGNG=yes\n",
    }

    # This is not strictly needed
    cron { "nighty_pkgng_update":
      command => "/usr/local/sbin/pkg update -q",
      minute  => fqdn_rand(60),
      hour    => 2,
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
