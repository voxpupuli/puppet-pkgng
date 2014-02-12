define pkgng::repo (
    $release     = $::operatingsystemrelease,
    $packagehost = $name,
    $protocol    = 'http',
    $mirror_type = 'srv',
    $repopath    = '/${ABI}/latest',
    $ensure      = present,
) {
    include ::pkgng

    # do some validation
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

    file { "/usr/local/etc/pkg/repos/${name}.conf":
        ensure  => $ensure,
        content => template("${module_name}/repo.erb"),
        notify  => Exec['pkg update'],
    }

    # set firewall
    if $mirror_type =~ /(?i:srv)/ {
        $firewall_host = firewall_resolve_srv_targets($packagehost)
    } else {
        $firewall_host = $packagehost
    }

    # TODO: ftp protocol also needs additional ports (either passive or active)
    $firewall_port = $protocol ? {
        'http'  => 80,
        'https' => 443,
        'ftp'   => 21,
        'ssh'   => 22,
        default => false,
    }

    if $firewall_port != false and $ensure == 'present' {
        firewall::rule { "${module_name}-repo-${name}":
             direction   => 'out',
             protocol    => 'tcp',
             port        => $firewall_port,
             destination => $firewall_host
        }
    }
}
