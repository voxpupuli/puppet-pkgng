# This configures a single PkgNG repository. Instead of defining the repo
# with the repo URL, we split it up in hostname, mirror_type, protocol and
# repopath. This way, this resource can be integrated with possible firewalls
# better.
#
# @example to use the class
#   pkg::repo { 'pkg.example.com': }
#
# @param packagehost String host address of the server
# @param protocol String Transport for repo, from http, https, ftp, file or ssh
# @param mirror_type String of srv or http
# @param repopath Path at packagehost url server beginning with /
# @param enabled Boolean to enable or disable the repository
# @param priority Interger specifying the order of precedence in multi-repo
# @param pubkey String containing the full path to the public key to use
# @param fingerprints String containingthe full path to file containing valid fingerprints, see pkg.conf(8)
#
define pkgng::repo (
  String                                      $packagehost    = $name,
  Enum['file', 'ftp', 'http', 'https', 'ssh'] $protocol       = 'http',
  Enum['srv', 'http']                         $mirror_type    = 'srv',
  Stdlib::Absolutepath                        $repopath       = '/${ABI}/latest', # lint:ignore:single_quote_string_with_variables
  Boolean                                     $enabled        = true,
  Integer[0,100]                              $priority       = 0,
  Optional[Stdlib::Absolutepath]              $pubkey         = undef,
  Optional[Stdlib::Absolutepath]              $fingerprints   = undef,
) {
  include pkgng

  # define repository configuration
  file { "/usr/local/etc/pkg/repos/${name}.conf":
    content => template("${module_name}/repo.erb"),
    notify  => Exec['pkg update'],
  }
}
