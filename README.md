puppet-pkgng
===

A package provider for FreeBSD's PkgNG package manager.

This module contains the provider as well as some implementation around
configuring the pkg.conf file.  If you are building your own PkgNG packages,
you may also want to look at my [poudriere
module](https://github.com/xaque208/puppet-poudriere).

## Simple Iplementation

    class { "pkgng":
      packagesite => 'http://build.example.com/90amd64-default';
    }

