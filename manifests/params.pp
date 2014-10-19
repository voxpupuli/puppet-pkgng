# Class: pkgng::params
#
# Set some defaults
#
class pkgng::params {
  $pkg_dbdir    = '/var/db/pkg'
  $pkg_cachedir = '/var/cache/pkg'
  $portsdir     = '/usr/ports'
}
