# This configures the PkgNG Package manager on FreeBSD systems, and adds
# support for managing packages with Puppet.
class pkgng (
  $packagesite  = $pkgng::params::packagesite,
  $repo_name    = $pkgng::params::repo_name,
  $srv_mirrors  = $pkgng::params::srv_mirrors,
  $pkg_dbdir    = $pkgng::params::pkg_dbdir,
  $pkg_cachedir = $pkgng::params::pkg_cachedir,
  $portsdir     = $pkgng::params::portsdir,
  $prefix       = $pkgng::params::prefix,
) inherits pkgng::params {

  # At the time of this writing, only FreeBSD 9 and 10 are supported by pkgng
  if $::pkgng_supported {
    $config_content = "PKG_DBDIR: ${pkg_dbdir}\nPKG_CACHEDIR: ${pkg_cachedir}\n"

    if $srv_mirrors == 'YES' or $packagesite =~ /^pkg\+http/ {
      $mirror_type = 'SRV'
    } else {
      $mirror_type = 'HTTP'
    }

    file { "${prefix}/etc/pkg.conf":
      notify => Exec['pkg update'],
    }

    # from pkgng 1.1.4 and up, a different repo format is used
    if versioncmp($::pkgng_version, '1.1.4') >= 0 {
      # make sure repo config dir is present
      file { "${prefix}/etc/pkg":
        ensure => directory,
      }

      file { "${prefix}/etc/pkg/repos":
        ensure => directory,
      }

      File["${prefix}/etc/pkg.conf"] {
        content => $config_content,
      }

      file { "${prefix}/etc/pkg/repos/${repo_name}.conf":
        content => "${repo_name}: {\n  url: ${$packagesite},\n  mirror_type: ${mirror_type},\n  enabled: true,\n}",
        notify  => Exec['pkg update'],
      }
    } else {
      File["${prefix}/etc/pkg.conf"] {
        content => "PACKAGESITE: ${packagesite}\n${config_content}",
      }
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
      path        => "${prefix}/sbin",
      refreshonly => true,
      command     => 'pkg -q update -f',
    }

    # This exec should really on ever be run once, and only upon converting to
    # pkgng.  If you are building up a new system where the only software that
    # has been installed form ports is the pkgng itself, then the pkg database
    # is already up to date, and this is not required.  As you will see,
    # refreshonly, but nothing notifies this.  I am uncertain at this time how
    # to proceed, other than manually.
    exec { 'convert pkg database to pkgng':
      path        => "${prefix}/sbin",
      refreshonly => true,
      command     => 'pkg2ng',
    }
  } else {
    notice('pkgng is not supported on this release')
  }
}
