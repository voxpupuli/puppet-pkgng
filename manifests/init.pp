class pkgng (
  $packgesite = inline_template("http://pkgbeta.freebsd.org/freebsd-<%= kernelversion.split('.').first %>-${architecture}/latest/")
) {

  # At the time of this writing, only FreeBSD 9 and 10 are supported by pkgng
  if $kernel == 'FreeBSD' {
    if $pkgng_supported {
      file { "/usr/local/etc/pkg.conf":
        content  => "PACKAGESITE: ${packgesite}",
        notify   => Exec['pkg update'],
      }

      cron { "nighty_pkgng_update":
        command => "/usr/sbin/pkg update -q",
        minute  => fqdn_rand(60),
        hour    => 2,
        require => File["/usr/local/etc/pkg.conf"],
      }

      exec { "pkg update":
        path        => '/usr/local/sbin',
        refreshonly => true,
        command     => "pkg -q update",
      }

      exec { "convert pkg database to pkgng":
        path        => '/usr/local/sbin',
        refreshonly => true,
        command     => "pkg2ng",
      }
    } else {
      notice("pkgng is not supported on this release")
    }
  } else {
    notice("pkgng is not supported on this platform")
  }

}
