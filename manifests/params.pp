class pkgng::params {
  $packagesite  = inline_template("http://pkgbeta.freebsd.org/freebsd:<%= @kernelversion.split('.').first %>:${architecture}/latest/")
  $srv_mirrors  = 'NO'
  $pkg_dbdir    = '/var/db/pkg'
  $pkg_cachedir = '/var/cache/pkg'
  $portsdir     = '/usr/ports'
}
