# This configures a single PkgNG repository. Instead of defining the repo
# with the repo URL, we split it up in hostname, mirror_type, protocol and
# repopath. This way, this resource can be integrated with possible firewalls
# better.
#
# @example to use the class
#   pkg::repo { 'pkg.example.com': }
#
# @param packagehost Hostname of the repository
# @param protocol Transport used to reach the repository
# @param mirror_type Mirror type of the repository
# @param repopath Path of the repository on packagehost
# @param enabled Whether this repository is currently enabled
# @param priority Priority of the repository
# @param pubkey Path to the file containing  the public key for this repository
# @param fingerprints Path to the file containing known signatures for the repository
#
define pkgng::repo (
  String[1]                      $packagehost    = $name,
  Pkgng::Protocol                $protocol       = 'http',
  Pkgng::Mirror_type             $mirror_type    = 'srv',
  Stdlib::Absolutepath           $repopath       = '/${ABI}/latest', # lint:ignore:single_quote_string_with_variables
  Boolean                        $enabled        = true,
  Integer[0,100]                 $priority       = 0,
  Optional[Stdlib::Absolutepath] $pubkey         = undef,
  Optional[Stdlib::Absolutepath] $fingerprints   = undef,
) {
  include pkgng

  # define repository configuration
  file { "/usr/local/etc/pkg/repos/${name}.conf":
    content => epp("${module_name}/repo.epp", {
        name         => $name,
        packagehost  => $packagehost,
        protocol     => $protocol,
        mirror_type  => $mirror_type,
        repopath     => $repopath,
        enabled      => $enabled,
        priority     => $priority,
        pubkey       => $pubkey,
        fingerprints => $fingerprints,
    }),
    notify  => Exec['pkg update'],
  }
}
