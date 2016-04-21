# This configures a single PkgNG repository. Instead of defining the repo
# with the repo URL, we split it up in hostname, mirror_type, protocol and
# repopath. This way, this resource can be integrated with possible firewalls
# better.

define pkgng::repo (
    $packagehost = $name,
    $protocol    = 'http',
    $mirror_type = 'srv',
    $repopath    = '/${ABI}/latest',
    $enabled     = true,
    $priority    = 0,
) {
  include ::pkgng

  validate_string($packagehost)
  # validate protocol against chosen mirror_type
  case $mirror_type {
    /(?i:srv)/: {
      if $protocol !~ /^(?i:http(s)?)$/ {
        fail("Mirror type ${mirror_type} support http:// and https:// only")
      }
    }
    /(?i:http)/: {
      if $protocol !~ /^(?i:^(http|https|ftp|file|ssh))$/ {
        fail("Mirror type ${mirror_type} support http://, https://, ftp://, file://, ssh:// only")
      }
    }
    default: {
      fail("Mirror type ${mirror_type} not supported")
    }
  }
  validate_absolute_path($repopath)
  if is_string($enabled) {
    validate_re($enabled, ['^yes$', '^no$'])
  } else {
    validate_bool($enabled)
  }
  validate_integer($priority, 100)

  # define repository configuration
  file { "/usr/local/etc/pkg/repos/${name}.conf":
    content => template("${module_name}/repo.erb"),
    notify  => Exec['pkg update'],
  }
}
