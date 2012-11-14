puppet-pkgng
===

A package provider for FreeBSD's PkgNG package manager.

## Simple Iplementation

    class { "pkgng":
      packagesite => 'http://build.example.com/90amd64-default';
    }

