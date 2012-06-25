class pkgng {

  #package { "ports-mgmt/pkg": }

  file { "/usr/local/etc/pkg.conf":
    source => "puppet:///os/freebsd/usr/local/etc/pkg.conf",
    #require => Package["ports-mgmt/pkg"],
  }

  cron { "nighty_pkgng_update":
    command => "/usr/sbin/pkg update -q",
    minute  => fqdn_rand(60),
    hour    => 2,
    require => File["/usr/local/etc/pkg.conf"],
  }

}
