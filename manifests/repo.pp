# This configures a single PkgNG repository. Instead of defining the repo
# with the repo URL, we split it up in hostname, mirror_type, protocol and
# repopath. This way, this resource can be integrated with possible firewalls
# better.

define pkgng::repo (
    $packagehost = $name,
    $release     = $::operatingsystemrelease,
    $protocol    = 'http',
    $mirror_type = 'srv',
    $repopath    = '/${ABI}/latest',
    $enabled     = true,
) {
  include ::pkgng

  # validate protocol against chosen mirror_type
  case $mirror_type {
    /(?i:srv)/: {
      if $protocol !~ /(?i:http(s)?)/ {
        fail("Mirror type ${mirror_type} support http:// and https:// only")
      }
    }
    /(?i:http)/: {
      if $protocol !~ /(?i:(http|https|ftp|file|ssh))/ {
        fail("Mirror type ${mirror_type} support http://, https://, ftp://, file://, ssh:// only")
      }
    }
    default: {
      fail("Mirror type ${mirror_type} not supported")
    }
  }

  # define repository configuration
  file { "/usr/local/etc/pkg/repos/${name}.conf":
    content => template("${module_name}/repo.erb"),
    notify  => Exec['pkg update'],
  }
}
